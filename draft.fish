function draft
	md (octopress new draft $argv | grep -Eo '_.*\.md$')
end
