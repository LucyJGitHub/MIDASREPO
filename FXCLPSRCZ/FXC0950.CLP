/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FX Remove flags on unnetted net deals')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Foreign Exchange Module                             */
/*                                                                   */
/*       FXC0950 - Midas Input Cycle Termination                     */
/*                 Remove flags on Unnetted Deals                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD023716           Date 29Apr14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CDL002  *CREATE      DATE 29APR97            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD023716 - FX: Buy/Sell Net indicators reset to N           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CDL002 - FX Netting                                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                                    /*MD023716*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                                    /*MD023716*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                   /*MD023716*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                 /*MD023716*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Do not process if Switchable Feature CDL025 is switched on */                       /*MD023716*/
                                                                                        /*MD023716*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                      /*MD023716*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                      /*MD023716*/
             CHGVAR     VAR(&SARD) VALUE('CDL025')                                      /*MD023716*/
                                                                                        /*MD023716*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                       /*MD023716*/
             IF         COND(&RTN *EQ '       ') THEN(GOTO NORUN)                       /*MD023716*/
                                                                                        /*MD023716*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHGJOB     SWS(XXXXXX00)
 
/* Begin commitment control */
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
             OPNQRYF    FILE((DEALS *FIRST DEALSDBF)) OPTION(*ALL) +
                          QRYSLT('(((NETBY *EQ "Y") *AND (NETBR *EQ +
                          "                   ")) *OR ((NETSL *EQ +
                          "Y") *AND (NETSR *EQ "                   +
                          ")))') KEYFLD((DLNO)) COMMIT(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*  Update Flags on DEALSDB */
 
             CALL       PGM(FX0950)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FXC0950 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
 
 END:        ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 NORUN:                                                                                 /*MD023716*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
