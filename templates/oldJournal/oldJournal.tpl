{**
 * templates/index/site.tpl
 *
 * Copyright (c) 2013-2015 Simon Fraser University Library
 * Copyright (c) 2003-2015 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site index.
 *
 *}
{strip}
{assign var="pageTitle" value="navigation.oldJournal"}
{include file="common/header.tpl"}
{/strip}

<br />

{if $intro}<div id="intro">{$intro|nl2br}</div>{/if}

<a name="journals"></a>

{if $useAlphalist}
	<p>{foreach from=$alphaList item=letter}<a href="{url searchInitial=$letter sort="title"}">{if $letter == $searchInitial}<strong>{$letter|escape}</strong>{else}{$letter|escape}{/if}</a> {/foreach}<a href="{url}">{if $searchInitial==''}<strong>{translate key="common.all"}</strong>{else}{translate key="common.all"}{/if}</a></p>
{/if}

{iterate from=journals item=journal}
<div class="journalcontainer">
  <div class="containerfixed">
	{if $site->getSetting('showThumbnail')}
		{assign var="displayJournalThumbnail" value=$journal->getLocalizedSetting('journalThumbnail')}
		<div style="clear:left;">
		{if $displayJournalThumbnail && is_array($displayJournalThumbnail)}
			{assign var="altText" value=$journal->getLocalizedSetting('journalThumbnailAltText')}
			<div class="homepageImage"><a href="{url journal=$journal->getPath()}" class="action"><img src="{$journalFilesPath}{$journal->getId()}/{$displayJournalThumbnail.uploadName|escape:"url"}" {if $altText != ''}alt="{$altText|escape}"{else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if} /></a></div>
		{/if}
		</div>
	{/if}
  </div>
  <div class="containerflex">
	{if $site->getSetting('showTitle')}
		<h3>{$journal->getLocalizedTitle()|escape}</h3>
	{/if}
	{if $site->getSetting('showDescription')}
		{if $journal->getLocalizedDescription()}
			<div class="journalDescription" id="journalDescription-{$journal->getId()|escape}">
				{$journal->getLocalizedDescription()|nl2br}
			</div>
		{/if}
	{/if}
	<p><a href="{url journal=$journal->getPath()}" class="action">{translate key="site.journalView"}</a> | <a href="{url journal=$journal->getPath() page="issue" op="current"}" class="action">{translate key="site.journalCurrent"}</a> | <a href="{url journal=$journal->getPath() page="user" op="register"}" class="action">{translate key="site.journalRegister"}</a></p>
  </div>
</div>
<div class="journalseparator"></div>
{/iterate}
{if $journals->wasEmpty()}
	{translate key="site.noJournals"}
{/if}

<div id="journalListPageInfo">{page_info iterator=$journals}</div>
<div id="journalListPageLinks">{page_links anchor="journals" name="journals" iterator=$journals}</div>

{include file="common/footer.tpl"}
