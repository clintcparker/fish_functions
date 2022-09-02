function ss1-down --wraps='ssh -TO exit ss1' --description 'alias ss1-down=ssh -TO exit ss1'
  ssh -TO exit ss1 $argv; 
end
