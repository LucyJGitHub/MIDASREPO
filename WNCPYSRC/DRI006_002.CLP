000100210908/*********************************************************************/
000101210908/*                                                                   */
000102210908/*       MIDAS - /COPY Member GLC39                                  */
000103210908/*                                                                   */
000104210908/*       DRI006_002 - MIDAS GL Declare DRI006 Variables              */
000105210908/*                                                                   */
000106210908/*       Last Ament No. DRI006  *CREATE    DATE 01Jun21              */
000107210908/*                                                                   */
000108210908/*********************************************************************/
000109210908/*                                                                   */
000110210908/*       DRI006 - ACCNTAB COB save at monthend                       */
000111210908/*                                                                   */
000112210908/*********************************************************************/
000113210908                                                                                      /*DRI006*/
000114210908/**/                                                                                  /*DRI006*/
000115210908/* PERFORM ONLY IF GLC39 00002  */                                                    /*DRI006*/
000116210908/**/                                                                                  /*DRI006*/
000117210908             IF         COND(&FORB *EQ 'B') THEN(DO) /*DRI006*/
000118210908                                                                                      /*DRI006*/
000119210908/**/                                                                                  /*DRI006*/
000120210908/* CHECK IF DRI006 IS INSTALLED */                                                    /*DRI006*/
000121210908/**/                                                                                  /*DRI006*/
000122210908                CHGVAR     VAR(&RTCD) VALUE('       ') /*DRI006*/
000123210908                CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'DRI006' &AOFMT) /*DRI006*/
000125210908                                                                                      /*DRI006*/
000126210908/* IF FEATURE DRI006 IS 'ON' */                                                       /*DRI006*/
000127210908                                                                                      /*DRI006*/
000128210908                IF         COND(&RTCD *EQ ' ') THEN(DO) /*DRI006*/
000129210908                   CHGVAR     VAR(&DRI006) VALUE('Y') /*DRI006*/
000130210908                ENDDO      /*DRI006*/
000131210908                                                                                      /*DRI006*/
000132210908/**/                                                                                  /*DRI006*/
000133210908/* CHECK IF SYSTEM VALUE FOR THE LIBRARY WHERE ACCNTAB WILL BE COPIED */              /*DRI006*/
000134210908/**/                                                                                  /*DRI006*/
000135210908                                                                                      /*DRI006*/
000136210908                CHGVAR     VAR(&PRTCD) VALUE('       ') /*DRI006*/
000137210908                                                                                      /*DRI006*/
000138210908                CALL       PGM(AOSVALR0) PARM(&PRTCD &POPV01 &PVL01 &POP02 &PVL02 &POP03 +
000139210908                             &PVL03 &POP04 &PVL04 &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
000140210908                             &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10) /*DRI006*/
000142210908                                                                                      /*DRI006*/
000143210908                IF         COND(&PRTCD *EQ '       ' *AND &DRI006 *EQ 'Y') THEN(DO) /*DRI006*/
000145210908                                                                                      /*DRI006*/
000146210908                   CHGVAR     VAR(&SVALLIB) VALUE(%SST(&PVL01 1 10)) /*DRI006*/
000147210908                                                                                      /*DRI006*/
000148210908                   CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&SYSID) /*DRI006*/
000149210908                                                                                      /*DRI006*/
000150210908/* CHECK IF EOM AND IF SO, MAKE A COPY OF ACCNTAB */                                  /*DRI006*/
000151210908                                                                                      /*DRI006*/
000152210908                   CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR) /*DRI006*/
000153210908                                                                                      /*DRI006*/
000154210908                   IF         COND(&EOM *EQ 'Y' *AND &ERROR *EQ ' ') THEN(DO) /*DRI006*/
000156210908                                                                                      /*DRI006*/
000157210908                      CPYF       FROMFILE(&DMLIB/ACCNTAB) TOFILE(&SVALLIB/ACCNTAB) +
000158210908                                   MBROPT(*REPLACE) CRTFILE(*YES) /*DRI006*/
000160210908                                                                                      /*DRI006*/
000161210908                   ENDDO      /*DRI006*/
000162210908                                                                                      /*DRI006*/
000163210908                   IF         COND(&ERROR *EQ 'Y') THEN(DO) /*DRI006*/
000164210908                                                                                      /*DRI006*/
000165210908                      SNDPGMMSG  MSG('SD2000 - PROGRAM ERROR') TOMSGQ(MOPERQ) /*DRI006*/
000167210908                      CHGJOB     SWS(XXXXXXX1)
000168210908                                                                                      /*DRI006*/
000169210908                   ENDDO      /*DRI006*/
000170210908                                                                                      /*DRI006*/
000171210908                ENDDO      /*DRI006*/
000172210908                                                                                      /*DRI006*/
000173210908             ENDDO      /*DRI006*/
000174210908                                                                                      /*DRI006*/
000175210908/**********************************************************************/
000176210908/* End of /COPY DRI006_002                                           **/
000177210908/**********************************************************************/
