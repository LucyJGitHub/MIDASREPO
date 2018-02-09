/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE End Journalling on Generic Update Files')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0130 - End Jounalling of Generic Update Files            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CDE002  *CREATE    Date 06Apr00              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE002 - Data Export - CCRM Revenue Analysis.               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0130INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Determine if COB journalling is On */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CCB009')
 
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CCB009) VALUE('Y'))
 
/* End journal only if CCB009 is off                                 */
 
             IF         COND(&CCB009 *EQ 'N') THEN(DO)
 
             SNDPGMMSG  MSG('DEC0130 - End Journalling on Generic +
                          Update Files') TOMSGQ(MRUNQ)
 
/**/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0130MPS                                          */
 
/* Ensure no pending changes exist on journal created by DEC0120     */
 
             RMVJRNCHG  JRN(JDEC0120) FILE((DEPTRANPD) (DEGTRANPD) +
                         (DEGPOSNPD) (DEGEVNTPD) (DEGVALUPD))
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801)
 
/* End journalling on all files                                      */
 
             ENDJRNPF   FILE(*ALL) JRN(JDEC0120)
             MONMSG MSGID(CPF0000)
 
/* Delete journal and receivers                                      */
 
             DLTJRN     JRN(JDEC0120)
             MONMSG MSGID(CPF0000)
 
/* Change job attributes for INQMSGRPY so that "RECEIVER NEVER       */
/* HAD FULL SAVE" messages are answered automatically by the         */
/* program, then change the job again to the original state          */
/* after receivers have been deleted                                 */
 
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRDEC0120)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
 
/*/COPY WNCPYSRC,DEC0130MPE                                          */
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0130ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0130 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0130END                                          */
 
             ENDPGM
