function cs-status --wraps='ssh -TO check cs' --description 'alias cs-status=ssh -TO check cs'
  ssh -TO check cs $argv; 
end
