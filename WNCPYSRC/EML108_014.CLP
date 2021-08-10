/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/**/                                                                                      /*EML108*/
             IF         COND(&EML108 *EQ 'Y') THEN(DO)                                    /*EML108*/
/**/                                                                                      /*EML108*/
             IF         COND(&ENAM3 *EQ ' ') THEN(CHGVAR VAR(&ENAM3) +
                          VALUE('0'))
             IF         COND(&ENAM4 *EQ ' ') THEN(CHGVAR VAR(&ENAM4) +
                          VALUE('0'))
             IF         COND(&ENAM5 *EQ ' ') THEN(CHGVAR VAR(&ENAM5) +
                          VALUE('0'))
             IF         COND(&DBTYP *EQ 'Y') THEN(DO)
/**********  CALL       PGM(MCCF84A) PARM(&RLEV &RENT &RPARM &CCCY)                       /*EML108*/
             CALL       PGM(XXCF84A) PARM(&RLEV &RENT &RPARM &CCCY)                       /*EML108*/
             RTVJOBA    SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR))
             GOTO       CMDLBL(CHECK)
             ENDDO

             IF         COND(&ABTYP *EQ 'Y') THEN(DO)
/**********  CALL       PGM(MCCF84B) PARM(&RLEV &RENT &RPARM &DTPDCT + */                 /*EML108*/
/**********               &DTPDYR &DTPDNY &CCCY)                       */                 /*EML108*/
             CALL       PGM(XXCF84B) PARM(&RLEV &RENT &RPARM &DTPDCT +
                          &DTPDYR &DTPDNY &CCCY)                                          /*EML108*/
             RTVJOBA    SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR))
             GOTO       CMDLBL(CHECK)
             ENDDO
/**/                                                                                      /*EML108*/
             ENDDO                                                                        /*EML108*/
