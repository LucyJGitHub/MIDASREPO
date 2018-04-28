/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE RE & GL Extract for Prof Reports')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LERC25 - Retail & general ledger extract                    */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CLE075AC*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CLE075AC*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CLE075AC*/
/*                                                                   */                 /*CLE075AC*/
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1097376          Date 03Apr13              */
/*       Prev Amend No. CLE075AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 05Nov96              */
/*                      088022             DATE 21MAR96              */
/*                      MOF60              DATE 23MAR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1097376 - LERC25 task splits failed due to slow processing*/
/*                   of TS server.                                   */
/*       CLE075AC - COB Restructure - LE COB Optimisation Phase 1    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       088022 - Amended error conditioning                         */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM  PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
/**********  DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)           /*         /*CCB003 AR1097376*/
/**********  DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)/*         /*CCB003 AR1097376*/
/**********  DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)            /*         /*CCB003 AR1097376*/
/**********  DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)            /*         /*CCB003 AR1097376*/
/**********  DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600) /*         /*CCB003 AR1097376*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&STRRRN@) TYPE(*DEC) LEN(10 0)                             /*AR1097376*/
             DCL        VAR(&ENDRRN@) TYPE(*DEC) LEN(10 0)                             /*AR1097376*/
             DCL        VAR(&CSEQ2) TYPE(*DEC) LEN(2 0)                                /*AR1097376*/
             DCL        VAR(&CSEQ2C) TYPE(*CHAR) LEN(2)                                /*AR1097376*/
             DCLF       LEEXPRPD                                                       /*AR1097376*/
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
 
     SNDPGMMSG  MSG('Retail and General Ledger Extract') +
                                       TOMSGQ(MRUNQ)
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* Check if any problems with COB components file */                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                    /*CCB003*/
                                                                      /*CCB003*/
/*LOOP:*****  ALCOBJ     ((LEPEGLD *FILE *EXCL) +                     /*CCB003*/
/***********             (LEPEGLZ *FILE *EXCL) +                      /*CCB003*/
/***********             (LEPERED *FILE *EXCL) +                      /*CCB003*/
/***********             (LEPEREZ *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPGLD *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPGLZ *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPRED *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPREZ *FILE *EXCL) +                      /*CCB003*/
/***********             (ACCNTAB *FILE *SHRUPD))  +                  /*CCB003*/
/***********             WAIT(60)                        /* 088022 */ /*CCB003*/
/*********** MONMSG     CPF0000 EXEC(GOTO LOOP)          /* 088022 */ /*CCB003*/
/***********/                                                         /*CCB003*/
/****IF*COND(&STAT *EQ 'Y') THEN(DO)                                  /*CCB003*/
/***********/                                                         /*CCB003*/
/***********CPYF FROMFILE(XLEPGLD) TOFILE(LEPEGLD) MBROPT(*REPLACE)   /*CCB003*/
/***********MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                   /*CCB003*/
/***********       EXEC(CLRPFM FILE(LEPEGLD))                         /*CCB003*/
/***********CPYF FROMFILE(XLEPGLZ) TOFILE(LEPEGLZ) MBROPT(*REPLACE)   /*CCB003*/
/***********MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                   /*CCB003*/
/***********       EXEC(CLRPFM FILE(LEPEGLZ))                         /*CCB003*/
/***********CPYF FROMFILE(XLEPRED) TOFILE(LEPERED) MBROPT(*REPLACE)   /*CCB003*/
/***********MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                   /*CCB003*/
/***********       EXEC(CLRPFM FILE(LEPERED))                         /*CCB003*/
/***********CPYF FROMFILE(XLEPREZ) TOFILE(LEPEREZ) MBROPT(*REPLACE)   /*CCB003*/
/***********MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                   /*CCB003*/
/***********       EXEC(CLRPFM FILE(LEPEREZ))                         /*CCB003*/
/****ENDDO**                                                          /*CCB003*/
/***********/                                                         /*CCB003*/
/****ELSE*DO/                                                         /*CCB003*/
/***********/                                                         /*CCB003*/
/***********/                                                         /*CCB003*/
/****CPYF***    FROMFILE(LEPEGLD) TOFILE(XLEPGLD) MBROPT(*REPLACE)    /*CCB003*/
/****MONMSG*MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPGLD)) /*CCB003*/
/****CPYF***    FROMFILE(LEPEGLZ) TOFILE(XLEPGLZ) MBROPT(*REPLACE)    /*CCB003*/
/****MONMSG*MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPGLZ)) /*CCB003*/
/****CPYF***    FROMFILE(LEPERED) TOFILE(XLEPRED) MBROPT(*REPLACE)    /*CCB003*/
/****MONMSG*MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPRED)) /*CCB003*/
/****CPYF***    FROMFILE(LEPEREZ) TOFILE(XLEPREZ) MBROPT(*REPLACE)    /*CCB003*/
/****MONMSG*MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPREZ)) /*CCB003*/
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/****ENDDO**/                                                         /*CCB003*/
 
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('LEPRE' *CAT &CSEQC)       /*CCB003*/
/**********  CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                /*         /*CCB003 AR1097376*/
/**********  CHGVAR     VAR(&SNDDTAQ) VALUE('LEPRESERVE')            /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
             OVRDBF     FILE(LEEXPRPD) TOFILE(LEEXPRPD) MBR(&MEMBER)  /*CCB003*/
                                                                      /*CCB003*/
/**********  STRCMTCTL  LCKLVL(*CHG)                           /*CCB003 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                                                                      /*CCB003*/
/* If restart, do not wait for the data queue entry */                /*CCB003*/
/* Clear any old data queue message from server but ensure that an */ /*CCB003*/
/* 'END' message, sent from the end proc job is not lost */           /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&RESTART = 'Y') THEN(DO)                 /*CCB003*/
/**********  CHGVAR     VAR(&RCVWAIT) VALUE(5)                       /*         /*CCB003 AR1097376*/
/**********  CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)              /*         /*CCB003 AR1097376*/
/**********  CHGVAR     VAR(&RCVWAIT) VALUE(600)                     /*         /*CCB003 AR1097376*/
/**********  CHGVAR     VAR(&MSGLENGTH) VALUE(50)                    /*         /*CCB003 AR1097376*/
/**********  IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)    /*         /*CCB003 AR1097376*/
/**********  CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       /*         /*CCB003 AR1097376*/
/**********  ENDDO                                                   /*         /*CCB003 AR1097376*/
/**********  GOTO       CMDLBL(RESTART)                              /*         /*CCB003 AR1097376*/
               RCVF                                                                    /*AR1097376*/
               IF         COND(&LSTRRN *EQ 0) THEN(GOTO RCVFILE)                       /*AR1097376*/
               CHGVAR     VAR(&STRRRN@) VALUE(&LSTRRN +1)                              /*AR1097376*/
               CHGVAR     VAR(&ENDRRN@) VALUE(&ENDRRN)                                 /*AR1097376*/
             ENDDO                                                   /*         /*CCB003 AR1097376*/
             ELSE     DO                                                               /*AR1097376*/
               RCVF                                                                    /*AR1097376*/
RCVFILE:       IF       COND(&CSEQ *LT 1000) THEN(DO)                                  /*AR1097376*/
                 CHGVAR     VAR(&STRRRN@) VALUE(1)                                     /*AR1097376*/
                 CHGVAR     VAR(&ENDRRN@) VALUE(&NORE)                                 /*AR1097376*/
               ENDDO                                                                   /*AR1097376*/
               ELSE     DO                                                             /*AR1097376*/
                 CHGVAR     VAR(&CSEQ2C) VALUE(%SST(&CSEQC 4 2))                       /*AR1097376*/
                 CHGVAR     VAR(&CSEQ2) VALUE(&CSEQ2C)                                 /*AR1097376*/
                 CHGVAR     VAR(&STRRRN@) VALUE((&CSEQ2 * &NORE) +1 )                  /*AR1097376*/
                 CHGVAR     VAR(&ENDRRN@) VALUE((&CSEQ2 + 1) * &NORE)                  /*AR1097376*/
               ENDDO                                                                   /*AR1097376*/
             ENDDO                                                                     /*AR1097376*/
                                                                      /*CCB003*/
/***LOOP:                                                            /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/**Request*response*from*DTAQ*whether*to*run*job*again*or*end**/                /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/**********  CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                 /*         /*CCB003 AR1097376*/
/**********  CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/* Wait on reply for 5 minutes */                                     /*CCB003*/
/**********  CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)              /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/* If no reply, error message and terminate */                        /*CCB003*/
/**********  IF         COND(&MSGLENGTH = 0) THEN(DO)                /*         /*CCB003 AR1097376*/
/**********  SNDPGMMSG  MSG('No response from server for LERC25') +
                          TOMSGQ(MOPERQ MRUNQ)                       /*         /*CCB003 AR1097376*/
/**********  CHGJOB     SWS(XXXXXX11)                                /*         /*CCB003 AR1097376*/
/**********  GOTO       CMDLBL(END)                                  /*         /*CCB003 AR1097376*/
/**********  ENDDO                                                   /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/* If reply = END, terminate */                                       /*CCB003*/
/**********  IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)    /*         /*CCB003 AR1097376*/
/**********  CHGVAR     VAR(&STAT) VALUE('N')                        /*         /*CCB003 AR1097376*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)          /*         /*CCB003 AR1097376*/
/**********  GOTO       CMDLBL(END)                                  /*         /*CCB003 AR1097376*/
/**********  ENDDO                                                   /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/*/**Call*RETAIL & GENERAL LEDGER EXTRACT Program */                  /*CCB003*/
/***********                                                          /*CCB003*/
/*********** DLCOBJ     ((LEPEGLD *FILE *EXCL) +                      /*CCB003*/
/***********             (LEPEGLZ *FILE *EXCL) +                      /*CCB003*/
/***********             (LEPERED *FILE *EXCL) +                      /*CCB003*/
/***********             (LEPEREZ *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPGLD *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPGLZ *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPRED *FILE *EXCL) +                      /*CCB003*/
/***********             (XLEPREZ *FILE *EXCL))          /* 088022 */ /*CCB003*/
/*********** CALL       LER250                                        /*CCB003*/
                                                                      /*CCB003*/
/***RESTART:                                                         /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
             ALCOBJ     OBJ((ACCNTAB *FILE *SHRUPD))                  /*CCB003*/
                                                                      /*CCB003*/
/**********  CALL       PGM(LER250) PARM(&RESTART)                   /*         /*CCB003 AR1097376*/
             CALL       PGM(LER250) PARM(&STRRRN@ &ENDRRN@)                            /*AR1097376*/
                                                                      /*CCB003*/
             DLCOBJ     ((ACCNTAB *FILE *SHRUPD))                   /* 088022 */
 
  /* IF ERROR SEND MSG     */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
 
     ENDDO
     ELSE    GOTO   END                                                                /*AR1097376*/
 
/**********  CHGVAR     VAR(&RESTART) VALUE('N')                     /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/**********  GOTO       CMDLBL(LOOP)                                 /*         /*CCB003 AR1097376*/
                                                                      /*CCB003*/
/****ELSE*CMD(DO)                                                     /*CCB003*/
/***********                                                          /*CCB003*/
/**If*the*component has completed successfully reset the status field  *CCB003*/
/***********                                                          /*CCB003*/
/****CHGVAR*VAR(&STAT) VALUE('N')                                     /*CCB003*/
/****CALL*PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                         /*CCB003*/
/***********                                                          /*CCB003*/
/**&*clear*the action files */                                        /*CCB003*/
/***********                                                          /*CCB003*/
/***********CLRPFM FILE(ACTN5DH)                                      /*CCB003*/
/***********CLRPFM FILE(ACTN5DK)                                      /*CCB003*/
/***********CLRPFM FILE(ACTN5DN)                                      /*CCB003*/
/***********CLRPFM FILE(ACTN5ZX)                                      /*CCB003*/
/****ENDDO**                                                          /*CCB003*/
 
ABNOR:                                                                /*CCB003*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('Program LERC25 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
END:                                                                  /*CCB003*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
