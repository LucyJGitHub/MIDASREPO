/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail account margin history update ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3669 - Retail Account Margin History Update Control      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CDE002  *CREATE    Date 14Dec99              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE002 - Retail Account Margin History Update Control       */
/*                 New Program                                       */
/*                                                                   */
/*********************************************************************/
             PGM   PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,REC3669INT                                          */
 
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&BUSY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRTCD)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN)  TYPE(*CHAR) LEN(7) +
                        VALUE('*VERIFY')
             DCL        VAR(&SSARD)  TYPE(*CHAR) LEN(6) +
                        VALUE('CDE002')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('REC3669 - Retail Account Margin History +
                          Update') TOMSGQ(MRUNQ)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**/
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC3669MPS                                          */
 
/**/
/* Determine if CCRM is installed */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/* CCRM not intalled */
/**/
             IF         COND(&SRTCD *NE '       ') THEN(DO)
                GOTO END
             ENDDO
 
/* Check for component restart                                      */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If restart, restore saved file                                   */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/XREHMRGPD) TOFILE(REHMRGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(REHMRGPD))
 
/* Change flag to not busy              */
 
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* Save file                                                        */
 
             DLTF       FILE(&DPLIB/XREHMRGPD)
             MONMSG CPF0000
 
             CPYF       FROMFILE(REHMRGPD) TOFILE(&DPLIB/XREHMRGPD) +
                          CRTFILE(*YES)
             MONMSG CPC2957
 
/* Change flag to busy                  */
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Call Margin History update                                      */
 
             CALL  PGM(RE3669)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Delete security copy                                             */
             DLTF       FILE(&DPLIB/XREHMRGPD)
             MONMSG     MSGID(CPF0000)
 
/* Change flag to NOT BUSY              */
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/**/
/*/COPY WNCPYSRC,REC3669MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC3669ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC3669 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC3669END                                          */
 
 
             ENDPGM
