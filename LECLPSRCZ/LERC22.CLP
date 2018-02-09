/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loans Extract for Prof Reports')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC22  - Loans extract - 1st level                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE075AM           Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      156766             Date 16Mar99              */
/*                      E52101             Date 29Mar93              */
/*                      BH3498             Date 16Sep92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE075AM - COB Restructure - LE COB Optimisation Phase 1    */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       156766 - Clear RVLNSRV, RVLNSHH, and RVLNST2 after LER220   */
/*                has run.                                           */
/*       E52101 - Remove BH3498. This is no longer required as it    */
/*                causes reversed loans to be dropped too early      */
/*                from CLOANCL                                       */
/*       BH3498 - Copy CLOANCL to PETEMPLN for LER316, components    */
/*                now run before LEC0605.                            */
/*                                                                   */
/*********************************************************************/
 
/**********PGM  PARM(&CNAM &CSEQ)    */                                                   /*CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/****DCL*VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')                  */                   /*CLE075AM*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CLE075AM*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CLE075AM*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075AM*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075AM*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075AM*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075AM*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CLE075AM*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CLE075AM*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AM*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AM*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
 
     SNDPGMMSG  MSG('Loan Profitability Extract') +
                                       TOMSGQ(MRUNQ)
 
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
                                                                                        /*CLE075AM*/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AM*/
/* command SCWRTJREG */                                                                 /*CLE075AM*/
                                                                                        /*CLE075AM*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CLE075AM*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AM*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075AM*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075AM*/
                                                                                        /*CLE075AM*/
/**Check*the*current*status*of*this*component**/                                        /*CLE075AM*/
 
/****CALL*PGM(CB0160) PARM(&CNAM &CSEQ &STAT)                      */                   /*CLE075AM*/
 
/****IF*COND(&STAT *EQ 'Y') THEN(DO)                               */                   /*CLE075AM*/
 
/********** CPYF FROMFILE(XLEPLND) TOFILE(LEPELND) MBROPT(*REPLACE)*/                   /*CLE075AM*/
/********** MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPELND))                      */                   /*CLE075AM*/
/********** CPYF FROMFILE(XLEPLNZ) TOFILE(LEPELNZ) MBROPT(*REPLACE)*/                   /*CLE075AM*/
/********** MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPELNZ))                      */                   /*CLE075AM*/
/********** ENDDO                                                  */                   /*CLE075AM*/
 
/****ELSE*DO                                                       */                   /*CLE075AM*/
 
/****CPYF**     FROMFILE(LEPELND) TOFILE(XLEPLND) MBROPT(*REPLACE) */                   /*CLE075AM*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPLND))*/                 /*CLE075AM*/
/****CPYF**     FROMFILE(LEPELNZ) TOFILE(XLEPLNZ) MBROPT(*REPLACE) */                   /*CLE075AM*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPLNZ))*/                 /*CLE075AM*/
 
/**Set*the*status*to*failed*(&STAT*=*Y)*in*case*the*program*fails**/                    /*CLE075AM*/
 
/****CHGVAR VAR(&STAT) VALUE('Y')                                  */                   /*CLE075AM*/
/****CALL*PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                      */                   /*CLE075AM*/
 
/****ENDDO*                                                        */                   /*CLE075AM*/
 
/* */                                                                /*E52101*/
/** Remove BH3498 as this drops records from CLOANCL too early    */ /*E52101*/
/* */                                                                /*E52101*/
/**Start*of*Change**/                                     /*BH3498*/ /*E52101*/
/**Take*temporary*copy*of*PF/CLOANCL*for*Profitability*reporting     /*E52101*/
 
/************CPYF       FROMFILE(CLOAN) TOFILE(PETEMPLN) +
                          MBROPT(*REPLACE) RCDFMT(CLOANCLF)       */ /*E52101*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PETEMPLN))                         */ /*E52101*/
 
/**End*of*Change**/                                       /*BH3498*/ /*E52101*/
 
  /* Call LOANS EXTRACT Program */
 
/**********  CALL       LER220      */                                                    /*CLE134*/
             CALL       PGM(LER220) PARM(&RERUN)                                          /*CLE134*/
 
  /* IF ERROR SEND MSG       */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* If abnormal, retrieve attributes of current job */                                   /*CLE075AM*/
                                                                                        /*CLE075AM*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075AM*/
                                                                                        /*CLE075AM*/
/* Retrieve the most recent journal entry sequence number */                            /*CLE075AM*/
/* for the specific job */                                                              /*CLE075AM*/
                                                                                        /*CLE075AM*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075AM*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CLE075AM*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CLE075AM*/
             ENDDO                                                                      /*CLE075AM*/
                                                                                        /*CLE075AM*/
/* Determine starting journal sequence number of current job */                         /*CLE075AM*/
                                                                                        /*CLE075AM*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075AM*/
                                                                                        /*CLE075AM*/
/* Remove journal changes */                                                            /*CLE075AM*/
                                                                                        /*CLE075AM*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CLE075AM*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEPELND) (LEPELNZ)) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR) +
                          FROMENT(&START) TOENT(&FINISH)                                /*CLE075AM*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075AM*/
             ENDDO                                                                      /*CLE075AM*/
                                                                                        /*CLE075AM*/
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
     ELSE CMD(DO)
                                                                      /*156766*/
/* Clear files once they have been used by LER220 */                  /*156766*/
                                                                      /*156766*/
             CLRPFM     FILE(RVLNSHH)                                 /*156766*/
             CLRPFM     FILE(RVLNSRV)                                 /*156766*/
             CLRPFM     FILE(RVLNST2)                                 /*156766*/
 
/**If*the*component*has*completed*successfully*reset*the*status*field**/                /*CLE075AM*/
 
/****CHGVAR VAR(&STAT) VALUE('N')                                  */                   /*CLE075AM*/
/****CALL*PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                      */                   /*CLE075AM*/
 
     ENDDO
 
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AM*/
/* command SCWRTJREG */                                                                 /*CLE075AM*/
                                                                                        /*CLE075AM*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CLE075AM*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AM*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CLE075AM*/
                                                                                        /*CLE075AM*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/**********ENDPGM */                                                                      /*CLE134*/
ENDPGM: ENDPGM                                                                            /*CLE134*/
