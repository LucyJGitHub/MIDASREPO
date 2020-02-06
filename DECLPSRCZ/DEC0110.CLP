/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DE Input extract control information')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0110 - Input Extract Control Information                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK016             Date 04Jun03              */
/*                      208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002             Date 04Jun04              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 08Dec99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       208221 - Default Margin from Rate/Spread changes            */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
/*/COPY WNCPYSRC,DEC0110INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&EXCTCHG) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&COBST)  TYPE(*CHAR) LEN(4)                                   /*CCB020*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0110MPS                                          */
 
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                                   */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
 
/* Try and allocate DEOLEJPD - if it fails, the CCRM - Limits Drip   */
/* Feed Transfer job is active. This input can't be done now.        */
 
              ALCOBJ     OBJ((DEOLEJPD *FILE *EXCL)) WAIT(0)
              MONMSG     MSGID(CPF0000) EXEC(DO)
               CALL       PGM(SDC0700) PARM('DEC0110' 'CANTRUNNOW' ' ')
               GOTO       CMDLBL(END)
              ENDDO
 
              DLCOBJ     OBJ((DEOLEJPD *FILE *EXCL))
              MONMSG     MSGID(CPF0000)
 
/*    Call input function                                            */
 
             IF         COND(&MODE *NE '3') THEN(DO)
 
/**/
/** If not being run as part of the I/C, then journal DEOLEJPD       */
/**/
             STRJRNPF   FILE(DEOLEJPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                                    /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(DEINPEXCT) PARM(&EXCTCHG)
 
/*    Error processing                                               */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,DEC0110MPE                                          */
 
/*    Update period end dates                                        */
/*    (if the extract control information has been changed)          */
 
             IF         COND(&EXCTCHG *EQ 'Y') THEN(DO)
             CALL       PGM(DEC0010)
             ENDDO
 
             ELSE       CMD(DO)
               CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
               CHGJOB     SWS(XXXXXX00)
             ENDDO
             ENDDO
 
/*    Call Customer Lending Funding Rate Utility                    */ /*CDE002*/
/*    only if called from switchable feature installation program   */ /*CDE002*/
/*    selection                                                     */ /*CDE002*/
                                                                       /*CDE002*/
             IF         COND((&MODE *EQ '1') *OR (&MODE *EQ '2')) +
                          THEN(DO)                                     /*CDE002*/
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)           /*CDE002*/
             CALL       PGM(DE0110)                                    /*CDE002*/
             CALL       PGM(DE0120)                                    /*CDE002*/
/*    Call Retail Margin Rate Utility                               */ /*208221*/
/*    only if called from switchable feature installation program   */ /*208221*/
                                                                       /*208221*/
             CALL       PGM(DE0130)                                    /*208221*/
             ENDDO                                                     /*CDE002*/
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0110ERR                                          */
 
/* Abnormal termination */
 
            CHGJOB     SWS(XXXXXX11)
            SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                       TOPGMQ(*EXT) TOMSGQ(MOPERQ)
            MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/**********  IF         COND(&PHASE *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&COBST  *EQ '*YES') THEN(DO)                                 /*CCB020*/
/**/
/** If not being run as part of the I/C, then end commitment control */
/** and jounalling.                                                  */
/**/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(DEOLEJPD) JRN(ICJRN)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/*/COPY WNCPYSRC,DEC0110END                                          */
 
ENDPGM
