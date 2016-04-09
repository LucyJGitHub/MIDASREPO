/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account Transfer Update GLHIBLPD/GLAVBLPD')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC18200 - Midas GL Account Transfer Update GLHIBLPD        */
/*                   and GLAVBLPD                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. AR697178           Date 17Jan11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27413A          Date 28Apr10              */
/*                      BUG27413 *CREATE   Date 12Apr10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR697178 - GLHIBLPD and GLAVBLPD were not processed by      */
/*                  ATU (Child: AR697179)                            */
/*       BUG27413A - ACTFR 00001 - Added member already exists       */
/*       BUG27413 - ACCTFR 00001 - File member not found             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRCD &RFNO &FRAC &TOAC &RTCD)
 
 
             DCL        VAR(&MEM)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRCD)      TYPE(*CHAR) LEN(4)
             DCL        VAR(&RFNO)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRAC)      TYPE(*CHAR) LEN(24)
             DCL        VAR(&TOAC)      TYPE(*CHAR) LEN(24)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
 
             DCLF       FILE(GLHBCGPD)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDMSG     MSG('GLC18200 - Account Transfer Update +
                          GLHIBLPD and GLAVBLPD') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 READ:       RCVF       RCDFMT(GLHBCGD0)
 
/** End of File */
 
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
 
/** Check if Control group exist as a member in GLHIBLPD  */
 
             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             GOTO       CMDLBL(SECND)
             ENDDO
 
/** If member exists, add to GLHIBLL5 file  */
 
             CHKOBJ     OBJ(GLHIBLL5) OBJTYPE(*FILE) MBR(&HCCGCD)                      /*BUG27413A*/
             MONMSG     MSGID(CPF9815) EXEC(DO)                                        /*BUG27413A*/
             ADDLFM     FILE(GLHIBLL5) MBR(&HCCGCD) +
                          DTAMBRS((GLHIBLPD (&HCCGCD)))
             ENDDO                                                                     /*BUG27413A*/
 
/**********  OVRDBF     FILE(GLHIBLL5) TOFILE(GLHIBLL5) MBR(&HCCGCD) */                 /*AR697178*/
             OVRDBF     FILE(GLHIBLL5) MBR(&HCCGCD) OVRSCOPE(*JOB)                      /*AR697178*/
 
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(GL018200) PARM(&PRCD &RFNO &FRAC &TOAC &RTCD)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Check if Control group exist as a member in GLAVBLPD  */
 
SECND:       CHKOBJ     OBJ(GLAVBLPD) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             GOTO       CMDLBL(READ)
             ENDDO
 
/** If member exists, add to GLAVBLL4 file  */
 
             CHKOBJ     OBJ(GLAVBLL4) OBJTYPE(*FILE) MBR(&HCCGCD)                      /*BUG27413A*/
             MONMSG     MSGID(CPF9815) EXEC(DO)                                        /*BUG27413A*/
             ADDLFM     FILE(GLAVBLL4) MBR(&HCCGCD) +
                          DTAMBRS((GLAVBLPD (&HCCGCD)))
             ENDDO                                                                     /*BUG27413A*/
 
/**********  OVRDBF     FILE(GLAVBLL4) TOFILE(GLAVBLL4) MBR(&HCCGCD) */                 /*AR697178*/
             OVRDBF     FILE(GLAVBLL4) MBR(&HCCGCD) OVRSCOPE(*JOB)                      /*AR697178*/
 
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(GL019700) PARM(&PRCD &RFNO &FRAC &TOAC &RTCD)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**********  RMVM       FILE(GLHIBLL5) MBR(&HCCGCD)   */                               /*BUG27413A*/
/**********  MONMSG     MSGID(CPF0000 RPG0000)        */                               /*BUG27413A*/
/**********  RMVM       FILE(GLAVBLL4) MBR(&HCCGCD)   */                               /*BUG27413A*/
/**********  MONMSG     MSGID(CPF0000 RPG0000)        */                               /*BUG27413A*/
 
/* Read next record */
 
             IF         COND(&PRCD *EQ '*LR') THEN(DO)
             RMVM       FILE(GLHIBLL5) MBR(*ALL)                                       /*BUG27413A*/
             MONMSG     MSGID(CPF0000 RPG0000)                                         /*BUG27413A*/
             RMVM       FILE(GLAVBLL4) MBR(*ALL)                                       /*BUG27413A*/
             MONMSG     MSGID(CPF0000 RPG0000)                                         /*BUG27413A*/
             DLTOVR     FILE(*ALL)                                                      /*AR697178*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                  /*AR697178*/
             GOTO       CMDLBL(EOF)
             ENDDO
 
             GOTO       CMDLBL(READ)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RTCD) VALUE('F')
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC18200 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 EOF:        RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
