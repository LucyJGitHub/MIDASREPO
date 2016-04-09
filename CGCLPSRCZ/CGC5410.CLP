/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Summary of Correspond. Items Extract')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - USER DEFINED CORRESPONDENCE                     */
/*                                                                   */
/*       CGC5410 - Print Summary of Correspondence Items - Extract   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 087933             DATE 18MAY95              */
/*       PREV AMEND NO. 086133             DATE 09MAR95              */
/*                      S01522             DATE 05DEC94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       087933 - Add CGPGENL4 member                                */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Parameters received for RCF                                       */
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)
 
 
/* General */
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTIONS)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&RARCH)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&LAST_CNF)    TYPE(*CHAR) LEN(1)          /*087933*/
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)          /*087933*/
 
/* Selection for OPNQRYF */
             DCL        VAR(&SELECT)      TYPE(*CHAR) LEN(512)
 
 
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Copyright Statement                                               */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('CGC5410 - Print Summary of +
                          Correspondence Items - Extract') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)             /*086133*/
             OVRMSGF    MSGF(MIDAS   ) TOMSGF(GBMIDAS   )             /*086133*/
 
 
 
/* Call the SELECT statement setup program */
             CALL    PGM(CGC5420) PARM(&RPARM &RBCH &SELECT &OPTIONS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNORMAL)
                ENDDO
 
 
/* Current or Archive */
             CHGVAR     VAR(&RARCH)    VALUE(%SST(&RPARM 94 1))
             CHGVAR     VAR(&LAST_CNF) VALUE(%SST(&RPARM 97 1))       /*087933*/
 
             IF         COND(&RARCH   *EQ 'A') THEN(DO)
                 OVRDBF     FILE(CGXDCRPD) SHARE(*YES)
/* Run OPNQRYF */
             OPNQRYF    FILE((CGXDCRPD)) OPTION(*ALL) +
                          QRYSLT(&SELECT) KEYFLD((DRBRCA) (DRARDT)) +
                          OPNID(CGXDCRPD)
                 ENDDO
             ELSE       CMD(DO)
                 OVRDBF     FILE(CGUDCRPD) SHARE(*YES)
/* Run OPNQRYF */
             OPNQRYF    FILE((CGUDCRPD)) OPTION(*ALL) +
                          QRYSLT(&SELECT) KEYFLD((DRBRCA) (DRARDT)) +
                          OPNID(CGUDCRPD)
                 ENDDO
 
/* */                                                                 /*087933*/
/* If only last confirmation do extra processing */                   /*087933*/
/* */                                                                 /*087933*/
             IF         COND(&LAST_CNF *EQ 'Y') THEN(DO)              /*087933*/
             IF         COND(&RARCH *EQ 'A') THEN(DO)                 /*087933*/
/* */                                                                 /*087933*/
/* Check that extract file does not exist */                          /*087933*/
/* */                                                                 /*087933*/
             CHKOBJ     OBJ(QTEMP/Q_CGXDCRPD) OBJTYPE(*FILE)          /*087933*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP2))       /*087933*/
             DLTF       FILE(QTEMP/Q_CGXDCRPD)                        /*087933*/
/* */                                                                 /*087933*/
/* Copy selected records and close file */                            /*087933*/
/* */                                                                 /*087933*/
 SKIP2:      CPYFRMQRYF FROMOPNID(CGXDCRPD) TOFILE(QTEMP/Q_CGXDCRPD) +
                          MBROPT(*ADD) CRTFILE(*YES)                  /*087933*/
             CLOF       OPNID(CGXDCRPD)                               /*087933*/
/* */                                                                 /*087933*/
/* Reorder file and select print item types */                        /*087933*/
/* */                                                                 /*087933*/
             OPNQRYF    FILE((Q_CGXDCRPD)) OPTION(*ALL) +
                          QRYSLT('(DRPTYP *eq "DEAL_DEAL ") *or   +
                          (DRPTYP *eq "TRADE     ") *or (DRPTYP *eq +
                          "DEPOTM_WIO") *or (DRPTYP *eq "DEPOTM_DT +
                          ") *or (DRPTYP *eq "DEPOTM_BBL") *or +
                          (DRPTYP *eq "DEPOTM_PR")') +
                          KEYFLD((DRPRTD) (DRPTYP) (DRPSTP) +
                          (DRPCOR) (DRDCOR) (DRMTRN) (DRITEM +
                          *DESCEND)) OPNID(CGUDCRPD) /*087933*/
             OVRDBF     FILE(CGUDCRPD) TOFILE(Q_CGXDCRPD) +
                          SHARE(*YES)                                 /*087933*/
/* */                                                                 /*087933*/
/* Call program to delete duplicates */                               /*087933*/
/* */                                                                 /*087933*/
             CALL       PGM(CG5289) PARM(&RTN_CODE '          ')      /*087933*/
/* */                                                                 /*087933*/
/* Check for error */                                                 /*087933*/
/* */                                                                 /*087933*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*087933*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)            /*087933*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*087933*/
             GOTO       CMDLBL(ABNORMAL)                              /*087933*/
             ENDDO                                                    /*087933*/
/* */                                                                 /*087933*/
             CLOF       OPNID(CGXDCRPD)                               /*087933*/
/* */                                                                 /*087933*/
/* Reorder extract for report */                                      /*087933*/
/* */                                                                 /*087933*/
             OPNQRYF    FILE((Q_CGXDCRPD)) OPTION(*ALL) +
                          KEYFLD((DRBRCA) (DRARDT)) OPNID(CGXDCRPD)   /*087933*/
             OVRDBF     FILE(CGXDCRPD) TOFILE(Q_CGXDCRPD) +
                          SHARE(*YES)                                 /*087933*/
             ENDDO                                                    /*087933*/
             ELSE       CMD(DO)                                       /*087933*/
/* */                                                                 /*087933*/
/* Check that extract file does not exist */                          /*087933*/
/* */                                                                 /*087933*/
             CHKOBJ     OBJ(QTEMP/Q_CGUDCRPD) OBJTYPE(*FILE)          /*087933*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP1))       /*087933*/
             DLTF       FILE(QTEMP/Q_CGUDCRPD)                        /*087933*/
/* */                                                                 /*087933*/
/* Copy selected records and close file */                            /*087933*/
/* */                                                                 /*087933*/
 SKIP1:      CPYFRMQRYF FROMOPNID(CGUDCRPD) TOFILE(QTEMP/Q_CGUDCRPD) +
                          MBROPT(*ADD) CRTFILE(*YES)                  /*087933*/
             CLOF       OPNID(CGUDCRPD)                               /*087933*/
/* */                                                                 /*087933*/
/* Reorder file and select print item types */                        /*087933*/
/* */                                                                 /*087933*/
             OPNQRYF    FILE((Q_CGUDCRPD)) OPTION(*ALL) +
                          QRYSLT('(DRPTYP *eq "DEAL_DEAL ") *or   +
                          (DRPTYP *eq "TRADE     ")') +
                          KEYFLD((DRPRTD) (DRPTYP) (DRPSTP) +
                          (DRPCOR) (DRDCOR) (DRMTRN) (DRITEM +
                          *DESCEND)) OPNID(CGUDCRPD)                  /*087933*/
             OVRDBF     FILE(CGUDCRPD) TOFILE(Q_CGUDCRPD) +
                          SHARE(*YES)                                 /*087933*/
/* */                                                                 /*087933*/
/* Call program to delete duplicates */                               /*087933*/
/* */                                                                 /*087933*/
             CALL       PGM(CG5289) PARM(&RTN_CODE '          ')      /*087933*/
/* */                                                                 /*087933*/
/* Check for error */                                                 /*087933*/
/* */                                                                 /*087933*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*087933*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)            /*087933*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*087933*/
             GOTO       CMDLBL(ABNORMAL)                              /*087933*/
             ENDDO                                                    /*087933*/
/* */                                                                 /*087933*/
             CLOF       OPNID(CGUDCRPD)                               /*087933*/
/* */                                                                 /*087933*/
/* Reorder extract for report */                                      /*087933*/
/* */                                                                 /*087933*/
             OPNQRYF    FILE((Q_CGUDCRPD)) OPTION(*ALL) +
                          KEYFLD((DRBRCA) (DRARDT)) OPNID(CGUDCRPD)   /*087933*/
             ENDDO                                                    /*087933*/
             ENDDO                                                    /*087933*/
 
 
/* Call the Summary of Correspondence Items Report program           */
 
             CALL    PGM(CG5410) PARM(&RSEQ &RLVL &RBCH &RPARM &RARCH)
             IF         COND(&RARCH   *EQ 'A') THEN(DO)
             CLOF    OPNID(CGXDCRPD)
                 MONMSG MSGID(CPF0000 MCH0000)
                 ENDDO
             ELSE       CMD(DO)
             CLOF    OPNID(CGUDCRPD)
                 MONMSG MSGID(CPF0000 MCH0000)
                 ENDDO
 
 
 
/* Check for Database errors trapped by program */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNORMAL)
                ENDDO
 
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DMPCLPGM
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC5410 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5410 ended abnormally') MSGTYPE(*ESCAPE)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
 ENDCLPGM:
             RCLRSC     LVL(*CALLER)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
