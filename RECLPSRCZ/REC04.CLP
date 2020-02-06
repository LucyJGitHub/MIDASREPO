/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Customer exchanges file creation')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                                 */
/*                                                                  */
/*        REC04 - CUSTOMER EXCHANGES FILE CREATION                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD050374           Date 06Apr18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD024663           Date 25Jul16              */
/*                      253617             Date 25Jul16              */
/*                      MD031950           Date 17Jun15              */
/*                      CRE041             Date 28Sep12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001              Date 25Apr05             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408              Date 22Feb95             */
/*                      S01194              Date 09Mar90             */
/*                                                                  */
/********************************************************************/
/*       MD050374 - Condition clear of RECUSXQD                      */
/*       MD046248 - Finastra Rebranding                              */
/*       MD024663 - Input Document already exist error displays on   */
/*                  IC. Clear extension file when driving file is    */
/*                  cleared.                                         */
/*                - Applied for MD039114.                            */
/*       253617 - Dataara is being cleared during IC initialization  */
/*                to prevent error when reaching value of 9999.      */
/*              - Applied for MD039114.                              */
/*       MD031950 - Recompiled due to changed PF/CUSEXZ1.            */
/*       CRE041 - Enhancements to Customer Exchanges                 */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*        S01408 - ADDITION OF CORE HOOK REC04MPS                   */
/*        S01194 - NEW STANDING DATA                                */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*/COPY WNCPYSRC,REC04002                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CER001*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                                      /*CER001*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                                      /*CER001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CER001*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1)                                   /*CER001*/
             DCL        VAR(&CRE041) TYPE(*CHAR) LEN(1)                                   /*CRE041*/
/*/COPY WNCPYSRC,REC04001                                            */
             SNDPGMMSG  MSG('REC04 - Customer Exchanges File +
                          Creation') TOMSGQ(MRUNQ)
                                                                                          /*CER001*/
             CHGVAR     VAR(&SARD) VALUE('ULX043')                                        /*CER001*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CER001*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CER001*/
             CHGVAR     VAR(&ULX043) VALUE('N')                                           /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CER001*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                        VAR(&ULX043) VALUE('Y'))                                          /*CER001*/
                                                                                          /*CRE041*/
             CHGVAR     VAR(&SARD) VALUE('CRE041')                                        /*CRE041*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CRE041*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CRE041*/
             CHGVAR     VAR(&CRE041) VALUE('N')                                           /*CRE041*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CRE041*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                        VAR(&CRE041) VALUE('Y'))                                          /*CRE041*/
/**/
/*/COPY WNCPYSRC,REC04003                                            */
             CLRPFM FILE(CUSEXH1)
             IF         COND(&CRE041 *EQ 'N') THEN(DO)                                    /*CRE041*/
             CLRPFM FILE(CUSEXCE)
             ENDDO                                                                        /*CRE041*/
             CLRPFM FILE(CUSEXZ1)
/* Reset Last used customer exchange number data area                                     /*253617*/
             CHGDTAARA  DTAARA(CEXNO) VALUE('0000')                                       /*253617*/
/* Clear Extension file to prevent input error on next IC                               /*MD024663*/
             IF         COND(&CRE041 *EQ 'N') THEN(DO)                                  /*MD050374*/
             CLRPFM     FILE(RECUSXQD)                                                  /*MD024663*/
             ENDDO                                                                      /*MD050374*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC04MPS                                             /*S01408*/
             IF         COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        CLRPFM FILE(RECEX1PD)                                             /*CER001*/
                        MONMSG     MSGID(CPF0000)                                         /*CER001*/
             ENDDO                                                                        /*CER001*/
/**/                                                                  /*S01408*/
/**/
/*           OVRDBF FILE(TABLE) TOFILE(TABRE2)            */          /*S01194*/
/**/
             CALL PGM(RE0404)
/**/
/*           DLTOVR FILE(TABLE)                           */          /*S01194*/
/**/
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0404') TOMSGQ(MOPERQ)
               ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
