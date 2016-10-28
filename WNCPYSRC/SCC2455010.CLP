/*********************************************************************/
/*                                                                   */
/*       SCC2455010 - LUC109 - HOR processing                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/* */                                                                 /*LUC109*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*LUC109*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*LUC109*/
             CHGVAR     VAR(&SARD) VALUE('LUC109')                    /*LUC109*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*LUC109*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*LUC109*/
             CHGVAR     VAR(&LUC109) VALUE('Y')                       /*LUC109*/
             CALL       PGM(AOSVALR0) +
                          PARM(&RTCD 'TestSystemIndicator' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)            /*LUC109*/
             IF         COND(%SST(&SVAL1 1 4) *EQ 'LIVE') THEN(DO)    /*LUC109*/
                        CHGVAR VAR(&LIVE) VALUE('Y')                  /*LUC109*/
/* */                                                                 /*LUC109*/
/* Retrieve System Id */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*LUC109*/
                                                                      /*LUC109*/
             CHGVAR     VAR(&INTFLIB)  VALUE(&SYSID *CAT 'INTFLIB')   /*LUC109*/
/* If HOR extraction active wait.                                     /*LUC109*/
                                                                      /*LUC109*/
 WAIT:       RTVDTAARA  DTAARA(&INTFLIB/LUC109 (1 1)) +
                          RTNVAR(&STAT43)                             /*LUC109*/
             IF         COND(&STAT43 *EQ 'Y') THEN(DO)                /*LUC109*/
             DLYJOB     DLY(60)                                       /*LUC109*/
             GOTO       CMDLBL(WAIT)                                  /*LUC109*/
             ENDDO       /*LUC109*/
             ENDDO       /*LUC109*/
             ENDDO       /*LUC109*/
                                                                      /*LUC109*/
/*********************************************************************/
/* End of hook SCC2455010                                            */
/*********************************************************************/
