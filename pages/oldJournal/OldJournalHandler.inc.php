<?php

/**
 * @file pages/index/IndexHandler.inc.php
 *
 * Copyright (c) 2013-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class IndexHandler
 * @ingroup pages_index
 *
 * @brief Handle site index requests.
 */

import('classes.handler.Handler');

class OldJournalHandler extends Handler {
	/**
	 * Constructor
	 **/
	function OldJournalHandler() {
		parent::Handler();
	}

	/**
	 * If no journal is selected, display list of journals.
	 * Otherwise, display the index page for the selected journal.
	 * @param $args array
	 * @param $request Request
	 */
	function index($args, &$request) {
		$this->validate();
		$this->setupTemplate();

		$router =& $request->getRouter();
		$templateMgr =& TemplateManager::getManager();
		$journalDao =& DAORegistry::getDAO('JournalDAO');
		$journalPath = $router->getRequestedContextPath($request);
		$templateMgr->assign('helpTopicId', 'user.oldJournal');
		$journal =& $router->getContext($request);
		$site =& Request::getSite();

		if ($site->getRedirect() && ($journal = $journalDao->getById($site->getRedirect())) != null) {
			$request->redirect($journal->getPath());
		}

		$templateMgr->assign('intro', $site->getLocalizedIntro());
		$templateMgr->assign('journalFilesPath', $request->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/');

		// If we're using paging, fetch the parameters
		$usePaging = $site->getSetting('usePaging');
		if ($usePaging) $rangeInfo =& $this->getRangeInfo('journals');
		else $rangeInfo = null;
		$templateMgr->assign('usePaging', $usePaging);

		// Fetch the alpha list parameters
		$searchInitial = Request::getUserVar('searchInitial');
		$templateMgr->assign('searchInitial', $searchInitial);
		$templateMgr->assign('useAlphalist', $site->getSetting('useAlphalist'));

		$journals =& $journalDao->getOldJournals(
			$rangeInfo,
			$searchInitial?JOURNAL_FIELD_TITLE:JOURNAL_FIELD_SEQUENCE,
			$searchInitial?JOURNAL_FIELD_TITLE:null,
			$searchInitial?'startsWith':null,
			$searchInitial
		);
		$templateMgr->assign_by_ref('journals', $journals);
		$templateMgr->assign_by_ref('site', $site);

		$templateMgr->assign('alphaList', explode(' ', __('common.alphaList')));

		$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
		$templateMgr->display('oldJournal/oldJournal.tpl');
	}
}


?>
