/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member GLC39                                  */
/*                                                                   */
/*       DRI006_002 - MIDAS GL Declare DRI006 Variables              */
/*                                                                   */
/*       Last Ament No. MD059701           DATE 03Jun23              */
/*       Prev Ament No. DRI006  *CREATE    DATE 01Jun21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD059701 - Ensure ACCNTAB is deleted before copying so as to*/
/*                  avoid any failure due to format differences.     */
/*       DRI006 - ACCNTAB COB save at monthend                       */
/*                                                                   */
/*********************************************************************/
                                                                                      /*DRI006*/
/**/                                                                                  /*DRI006*/
/* PERFORM ONLY IF GLC39 00002  */                                                    /*DRI006*/
/**/                                                                                  /*DRI006*/
             IF         COND(&FORB *EQ 'B') THEN(DO) /*DRI006*/
                                                                                      /*DRI006*/
/**/                                                                                  /*DRI006*/
/* CHECK IF DRI006 IS INSTALLED */                                                    /*DRI006*/
/**/                                                                                  /*DRI006*/
                CHGVAR     VAR(&RTCD) VALUE('       ') /*DRI006*/
                CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'DRI006' &AOFMT) /*DRI006*/
                                                                                      /*DRI006*/
/* IF FEATURE DRI006 IS 'ON' */                                                       /*DRI006*/
                                                                                      /*DRI006*/
                IF         COND(&RTCD *EQ ' ') THEN(DO) /*DRI006*/
                   CHGVAR     VAR(&DRI006) VALUE('Y') /*DRI006*/
                ENDDO      /*DRI006*/
                                                                                      /*DRI006*/
/**/                                                                                  /*DRI006*/
/* CHECK IF SYSTEM VALUE FOR THE LIBRARY WHERE ACCNTAB WILL BE COPIED */              /*DRI006*/
/**/                                                                                  /*DRI006*/
                                                                                      /*DRI006*/
                CHGVAR     VAR(&PRTCD) VALUE('       ') /*DRI006*/
                                                                                      /*DRI006*/
                CALL       PGM(AOSVALR0) PARM(&PRTCD &POPV01 &PVL01 &POP02 &PVL02 &POP03 +
                             &PVL03 &POP04 &PVL04 &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                             &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10) /*DRI006*/
                                                                                      /*DRI006*/
                IF         COND(&PRTCD *EQ '       ' *AND &DRI006 *EQ 'Y') THEN(DO) /*DRI006*/
                                                                                      /*DRI006*/
                   CHGVAR     VAR(&SVALLIB) VALUE(%SST(&PVL01 1 10)) /*DRI006*/
                                                                                      /*DRI006*/
                   CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&SYSID) /*DRI006*/
                                                                                      /*DRI006*/
/* CHECK IF EOM AND IF SO, MAKE A COPY OF ACCNTAB */                                  /*DRI006*/
                                                                                      /*DRI006*/
                   CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR) /*DRI006*/
                                                                                      /*DRI006*/
                   IF         COND(&EOM *EQ 'Y' *AND &ERROR *EQ ' ') THEN(DO) /*DRI006*/
                                                                                      /*DRI006*/
                      DLTF       FILE(&SVALLIB/ACCNTAB)                                /*MD059701*/
                      MONMSG     MSGID(CPF2105)                                        /*MD059701*/
                      CPYF       FROMFILE(&DMLIB/ACCNTAB) TOFILE(&SVALLIB/ACCNTAB) +
                                   MBROPT(*REPLACE) CRTFILE(*YES) /*DRI006*/
                                                                                      /*DRI006*/
                   ENDDO      /*DRI006*/
                                                                                      /*DRI006*/
                   IF         COND(&ERROR *EQ 'Y') THEN(DO) /*DRI006*/
                                                                                      /*DRI006*/
                      SNDPGMMSG  MSG('SD2000 - PROGRAM ERROR') TOMSGQ(MOPERQ) /*DRI006*/
                      CHGJOB     SWS(XXXXXXX1)
                                                                                      /*DRI006*/
                   ENDDO      /*DRI006*/
                                                                                      /*DRI006*/
                ENDDO      /*DRI006*/
                                                                                      /*DRI006*/
             ENDDO      /*DRI006*/
                                                                                      /*DRI006*/
/**********************************************************************/
/* End of /COPY DRI006_002                                           **/
/**********************************************************************/
