/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Reorg. & archive facility history')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LERC04  - Reorganise and archive of facility history        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE075AA           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      240409             Date 19Jun06              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE075AA - COB Restructure - LE COB Optimisation Phase 1    */
/*       240409 - Fee History records are not purged. Apply 193112:- */
/*       193112 - Drop lending fee history records if associated loan*/
/*                or facility mo longer exists.                      */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                  /*CLE075AA*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                  /*CLE075AA*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CLE075AA*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CLE075AA*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075AA*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075AA*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075AA*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075AA*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CLE075AA*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CLE075AA*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AA*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AA*/
 
     SNDPGMMSG  MSG('Reorganise & Archive Facility History file') +
                                       TOMSGQ(MRUNQ)
 
/**/                                                                                    /*CLE075AA*/
/* WRITE CURRENT JOURNAL SEQUENCE NUMBER TO FILE SCJSEQPD  */                           /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
             CHGVAR     VAR(&CNAM) VALUE('LERC04')                                      /*CLE075AA*/
             CHGVAR     VAR(&CSEQ) VALUE(00001)                                         /*CLE075AA*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CLE075AA*/
             CHGVAR     VAR(&STEXT) VALUE('START OF ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AA*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075AA*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075AA*/
/**CLEAR*OUTPUT*FILES**************************************************              */ /*CLE075AA*/
 
/****CLRPFM NFHISH                                                                   */ /*CLE075AA*/
/****CLRPFM NFHISA                                                                   */ /*CLE075AA*/
/****CLRPFM AFHISH                                                                   */ /*CLE075AA*/
/****CLRPFM AFHISA                                                                   */ /*CLE075AA*/
/****CLRPFM NLFHST                                                            */ /*193112 CLE075AA*/
 
  /* Call Reorganise & Archive Program */
 
             CALL       LER040
 
  /* IF ERROR, SEND MSG  */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
/**/                                                                                    /*CLE075AA*/
/* RETRIEVE ATTRIBUTES OF CURRENT JOB  */                                               /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075AA*/
                                                                                        /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
/* RETRIEVE THE MOST RECENT JOURNAL ENTRY SEQUENCE NUMBER */                            /*CLE075AA*/
/* FOR THE SPECIFIC JOB                                   */                            /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075AA*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CLE075AA*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CLE075AA*/
             ENDDO                                                                      /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
/* DETERMINE STARTING JOURNAL SEQUENCE NUMBER OF CURRENT JOB */                         /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075AA*/
                                                                                        /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
/* REMOVE JOURNAL CHANGES */                                                            /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CLE075AA*/
             RMVJRNCHG  JRN(ICJRN) FILE((SDBSHSPD) (SDBSHSPA)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                   /*CLE075AA*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075AA*/
             ENDDO                                                                      /*CLE075AA*/
/**/                                                                                    /*CLE075AA*/
                                                                                        /*CLE075AA*/
     ENDDO
 
/****ELSE*DO                                                                         */ /*CLE075AA*/
 
/****CPYF**     FROMFILE(NFHISH) TOFILE(FACHISH) MBROPT(*REPLACE)                    */ /*CLE075AA*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FACHISH))                */ /*CLE075AA*/
 
/****CPYF**     FROMFILE(NFHISA) TOFILE(FACHISA) MBROPT(*REPLACE)                    */ /*CLE075AA*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FACHISA))                */ /*CLE075AA*/
 
/****CPYF**     FROMFILE(NLFHST) TOFILE(LEFHST) MBROPT(*REPLACE)              */ /*193112 CLE075AA*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEFHST))          */ /*193112 CLE075AA*/
 
/****CLRPFM NFHISH                                                                   */ /*CLE075AA*/
/****CLRPFM NFHISA                                                                   */ /*CLE075AA*/
/****CLRPFM NLFHST                                                            */ /*193112 CLE075AA*/
 
/****ENDDO                                                                           */ /*CLE075AA*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
