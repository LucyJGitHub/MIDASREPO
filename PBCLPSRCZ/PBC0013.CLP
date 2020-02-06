/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Define Template portfolio Maintenance')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBC0013  - Define Template Portfolio Maintenance            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CPB001  *CREATE    Date 07Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB001 - 'Private Banking' Module                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
              DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7)
              DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7)
              DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)
 
/* Reset external switches */
              CHGJOB    SWS(00000000)
 
/* Create LDA if not present */
              CHKOBJ    OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
              MONMSG    MSGID(CPF9801) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
              ENDDO
 
              CHGVAR     VAR(&RTCD) VALUE('       ')
              CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
              CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
              IF         COND(%SST(&FMT 65 1) *NE 'Y') THEN(DO)
             SNDPGMMSG  MSG('Option not allowed, Portfolio +
                          Management not installed.') TOPGMQ(*EXT)
                    GOTO       CMDLBL(END)
              ENDDO
 
/* Call program */
              CALL       PGM(PB0013)
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO      CMDLBL(ABNOR)
              ENDDO
 
              GOTO      CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
