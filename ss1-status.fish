function ss1-status --wraps='ssh -TO check ss1' --description 'alias ss1-status=ssh -TO check ss1'
  ssh -TO check ss1 $argv; 
end
