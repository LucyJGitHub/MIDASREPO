/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU BdC rates initialisation program')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Teller Support Module                        */
/*                                                                   */
/*       EUC0600 - EMU RTS BdC Rates Initialisation                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CEU024  *CREATE    Date 14Jul98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU024 - EMU Retail Teller Support Enhancement              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
/**/
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLAGE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CRT104) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/
/* Create LDA in QTEMP */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) +
                                   LEN(256)
             ENDDO
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/**/
/* Initialise data area and job switches */
/**/
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&FLAGE) VALUE('N')
/**/
/* Check if CRT104 is installed */
/**/
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSAR) VALUE('CRT104')
             CHGVAR     VAR(&CRT104) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSAR &SCSARD)
/**/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&CRT104) VALUE('Y'))
             IF         COND(&PRTCD *NE '       ' *AND +
                        &PRTCD *NE '*NRF   ') THEN(DO)
                        GOTO CMDLBL(ERROR)
             ENDDO
/**/
/* Check if CRT104 is installed */
/**/
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
             IF         COND(((&CRT104 = 'Y') *AND (&PMODE = '1')) +
                        *OR ((&CRT104 = 'Y') *AND (&PMODE = '2'))) +
                        THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                CRTJRNRCV  JRNRCV(&JLIB/JREUC0600)
                CRTJRN     JRN(&JLIB/JEUC0600) JRNRCV(&JLIB/JREUC0600)
                STRJRNPF   FILE(REBDCRPD) JRN(JEUC0600) IMAGES(*BOTH) +
                           OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&FLAGE) +
                           VALUE('Y'))
             ENDDO                                                    /*CCB009*/
/**********     STRCMTCTL  LCKLVL(*CHG)                                 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                CALL       PGM(EU0600) PARM(' ')
/**/
/* If error occurs after calling EU0600 */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                           ROLLBACK
                           ENDCMTCTL
                           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                               MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                           CHGVAR     VAR(&RTCDE) VALUE('*ERROR ')
                           GOTO     CMDLBL(DELETE)
                ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&FLAGE) VALUE('Y')
             GOTO    CMDLBL(DELETE)
/**/
/* To trap errors */
/**/
ERROR:       CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR ')
             CHGVAR     VAR(&FLAGE) VALUE('Y')
/**/
/* To delete journal and journal receiver */
/**/
DELETE:      IF         COND(((&CRT104 = 'Y') *AND (&PMODE = '1')) +
                        *OR ((&CRT104 = 'Y') *AND (&PMODE = '2'))) +
                        THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                        IF  COND(&FLAGE = 'N') THEN(ENDJRNPF +
                            FILE(REBDCRPD) JRN(&JLIB/JEUC0600))
             ENDDO                                                    /*CCB009*/
                        ENDCMTCTL
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                        DLTJRN     JRN(&JLIB/JEUC0600)
                        CHGJOB     INQMSGRPY(*DFT)
                        DLTJRNRCV  JRNRCV(&JLIB/JREUC0600)
                        MONMSG     MSGID(CPA7025)
                        CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
