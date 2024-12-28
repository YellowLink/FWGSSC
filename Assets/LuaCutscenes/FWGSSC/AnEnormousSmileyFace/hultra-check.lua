function onStay()
  if (player.StateMachine.State == 2) then
    setFlag("hultra", true)
  else
    setFlag("hultra", false)
  end
end
