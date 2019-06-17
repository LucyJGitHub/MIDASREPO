/*********************************************************************/               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*       Midas - /COPY Member SCC07                                  */               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*       SCC07005 - Midas SC Reopen input cycle                      */               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*       Last Amend No. JMI108             Date 31May18              */               /*JMI108*/
/*       Prev Amend No. TFJ011             Date 15Mar05              */               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*********************************************************************/               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */               /*JMI108*/
/*       TFJ011 - Account Pooling                                    */               /*TFJ011*/
/*                                                                   */               /*TFJ011*/
/*********************************************************************/               /*TFJ011*/
                                                                                      /*TFJ011*/
                                                                                      /*TFJ011*/
/*    Check if Account Pooling Feature is active                                      /*TFJ011*/
/**/                                                                                  /*TFJ011*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                    /*TFJ011*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                    /*TFJ011*/
/*           CHGVAR     VAR(&SARD) VALUE('TFJ011') */ /*TFJ011*/ /*JMI108*/
             CHGVAR     VAR(&SARD) VALUE('JMI108') /*JMI108*/
                                                                                      /*TFJ011*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD +
                          &SFMT)                                                      /*TFJ011*/
                                                                                      /*TFJ011*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                             /*TFJ011*/
                                                                                      /*TFJ011*/
/* Start A/C pooling receive job   */                                                 /*TFJ011*/
/*              CALL       PGM(GLCJ101) PARM('START' 'R') */ /*TFJ011*/ /*JMI108*/
                CALL       PGM(XXCJ111) PARM('START' 'R') /*JMI108*/
                                                                                      /*TFJ011*/
/* Start A/C pooling send job   */                                                    /*TFJ011*/
/*              CALL       PGM(GLCJ101) PARM('START' 'S') */ /*TFJ011*/ /*JMI108*/
                CALL       PGM(XXCJ111) PARM('START' 'S') /*JMI108*/
                                                                                      /*TFJ011*/
             ENDDO                                                                    /*TFJ011*/
/*********************************************************************/               /*TFJ011*/
/* End of /COPY SCC07                                                */               /*TFJ011*/
/*********************************************************************/               /*TFJ011*/
