/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Standing Orders Exception Report')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0733 - Standing Orders Exception Report Control          */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE013  *CREATE    Date 29Jul03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE013 - Report of Failed Standing Orders                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Declare parameters to AOSVALR0     */
/**/
             DCL        VAR(&CRE013) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       +
                          ')
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('ReptFailedSO')
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Initialise LDA         */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Reset Job switches     */
             CHGJOB     SWS(XXXXXX00)
 
/**/
/* Check if the current setting of Report Failed SO is 'Y'    */
/**/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)
             IF         COND(&PRTCD *EQ '       ') THEN(DO)
               CHGVAR     VAR(&CRE013) VALUE(%SUBSTRING(&PVL01 1 1))
             ENDDO
             ELSE       CMD(DO)
               SNDPGMMSG  MSG('Database Error in File SDSVALPD, Key +
                          ReptFailedSO') TOMSGQ(MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If the current setting of Report Failed SO is NOT 'Y', end program  */
             IF         COND(&CRE013 *NE 'Y') THEN(GOTO CMDLBL(END))
 
/* Call report program    */
             CALL       PGM(RE0733)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC0733 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
