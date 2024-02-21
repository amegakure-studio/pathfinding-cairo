import React, { useState } from 'react';
import { Snackbar, Button, Alert } from '@mui/material';

const CenteredSnackbar = ({ open, message, onClose }) => {
  const handleClose = () => {
    onClose();
  };

  return (
    <Snackbar 
      open={open} 
      anchorOrigin={{ vertical: 'top', horizontal: 'center' }} 
      autoHideDuration={6000} 
      onClose={handleClose}>
      <Alert onClose={handleClose} severity="error" sx={{ marginTop: '45px' }}>
        {message}
      </Alert>
    </Snackbar>
  );
};

export default CenteredSnackbar;
