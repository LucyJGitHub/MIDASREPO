/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Journal extract (COB)')                      */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0601  -  JOURNAL EXTRACT (COB)                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7286            Date 23May05              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      204748             Date 25Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E15759             Date 19AUG89              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       204748 - Restrict range of journal receivers used in DSPJRN */
/*                commands. Only need receivers used in input cycle. */
/*       E15759 - PROGRAM CHANGED SO THAT ONLY JOURNAL ENTRIES FOR FF*/                   /*E15759*/
/*                FILES WILL BE CONVERTED TO PF/JRNIMD.              */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                  */
/*   DECLARE VARIABLES                                              */
/*                                                                  */
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDICRCV) TYPE(*CHAR) LEN(10)                                /*204748*/
/*********** DCL        VAR(&ENDN) TYPE(*DEC) LEN(3 0)                           /*204748***CSC020*/
             DCL        VAR(&ENDN) TYPE(*DEC) LEN(8 0)                                    /*CSC020*/
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                 /*BUG7286*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                 /*CSC020*/
             DCL        VAR(&ENDSEQ) TYPE(*DEC) LEN(10 0)                                 /*CSC020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                  */
/* Audit message to MRUNQ                                           */
/*                                                                  */
            SNDPGMMSG  MSG('FFC0601 - Journal Extract') TOMSGQ(MRUNQ)
/*                                                                  */
/* Find journal library name                                        */
/*                                                                  */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(&JLIB) VALUE(&LIBID *CAT 'JLIB')
/*                                                                  */
/* Reset journal entries file                                       */
/*                                                                  */
             CLRPFM     FILE(JRNIMD)
             RMVM       FILE(JRNIM) MBR(JRNIM)
             MONMSG     MSGID(CPF7310) /* member not found */
             RMVM       FILE(JRNIM1) MBR(JRNIM1)
             MONMSG     MSGID(CPF7310) /* member not found */
 
/*                                                                  */
/* Set up journal entries file                                      */
/*                                                                  */
/* START OF FIX                                                         E15759*/
/*** DSPJRN     JRN(&JLIB/ICJRN) RCVRNG(*LIBL/ICRCV001 *CURRENT) +      E15759*/
/***************ENTTYP(UB UP PT DL DR BR UR ER) ENTDTALEN(512) +        E15759*/
/************** OUTPUT(*OUTFILE) OUTFILE(*LIBL/JRNIMD)                  E15759*/
/*********** DSPJRN     JRN(&JLIB/ICJRN) FILE((MARKTA *ALL) (MARKTD +                     /*204748*/
/***********              *ALL) (FOCLTA *ALL) (FOCLTD *ALL) (CHGCMA +                     /*204748*/
/***********              *ALL) (CHGCMD *ALL) (INTYPA *ALL) (INTYPD +                     /*204748*/
/***********              *ALL) (DEFLTA *ALL) (DEFLTD *ALL) (TRNORA +                     /*204748*/
/***********              *ALL) (TRNORD *ALL) (FACKYA *ALL) (FACKYD +                     /*204748*/
/***********              *ALL)) RCVRNG(*LIBL/ICRCV001 *CURRENT)    +                     /*204748*/
/***********              ENTTYP(UB UP PT DL DR BR UR ER) +                               /*204748*/
/***********              ENTDTALEN(512) OUTPUT(*OUTFILE) +                               /*204748*/
/***********              OUTFILE(JRNIMD)                                                 /*204748*/
/*                                                                  */                    /*204748*/
/*  Calculate last receiver saved at input cycle termination.       */                    /*204748*/
/*  Positions 11 to 20 of JNSTAT contain next receiver to be saved. */                    /*204748*/
/*  Subtract 1 from the receiver number to get the last one saved.  */                    /*204748*/
/*                                                                  */                    /*204748*/
             RTVDTAARA  DTAARA(JNSTAT (11 10)) RTNVAR(&ENDICRCV)                          /*204748*/
/*********** CHGVAR     VAR(&ENDN) VALUE(%SST(&ENDICRCV 6 3))                     /*204748**CSC020*/
             CHGVAR     VAR(&ENDN) VALUE(%SST(&ENDICRCV 3 8))                             /*CSC020*/
             CHGVAR     VAR(&ENDN) VALUE(&ENDN - 1)                                       /*204748*/
/*********** CHGVAR     VAR(%SST(&ENDICRCV 6 3)) VALUE(&ENDN)                     /*204748**CSC020*/
             CHGVAR     VAR(%SST(&ENDICRCV 3 8)) VALUE(&ENDN)                             /*CSC020*/
/*                                                                  */                    /*204748*/
/*  Display only journal entries created duing input cycle.         */                    /*204748*/
/*                                                                  */                    /*204748*/
/*********** DSPJRN     JRN(&JLIB/ICJRN) FILE((MARKTA *ALL) (MARKTD +
                          *ALL) (FOCLTA *ALL) (FOCLTD *ALL) (CHGCMA +
                          *ALL) (CHGCMD *ALL) (INTYPA *ALL) (INTYPD +
                          *ALL) (DEFLTA *ALL) (DEFLTD *ALL) (TRNORA +
                          *ALL) (TRNORD *ALL) (FACKYA *ALL) (FACKYD +
                          *ALL)) RCVRNG(*LIBL/ICRCV001 &ENDICRCV)   +
                          ENTTYP(UB UP PT DL DR BR UR ER) +
                          ENTDTALEN(512) OUTPUT(*OUTFILE) +
                          OUTFILE(JRNIMD)                                         /*204748**CSC020*/
/*                                                                                          CSC020*/
/*  Determine journal sequence number of next day set up.                                   CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) SEQ(&STRSEQ)                                *CSC020**BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set sequence to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRSEQ *EQ 0) THEN(DO)                                      /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNSEQNBR(&STRSEQ)                                              /*CSC020*/
             ENDDO                                                                        /*CSC020*/
/*                                                                                          CSC020*/
/*  Determine journal sequence number of end of input cycle.                                CSC020*/
/***(When*MPHAS*was*changed*to*'B')************************************         */ /*CSC020 CCB020*/
/*  (When MPHAS was changed to 'C')                                                    */ /*CCB020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(MPHAS) FLAG(B) SEQ(&ENDSEQ)                         *CSC020**BUG7286*/
/**********  SCRTVJEVT  EVENT(MPHAS) FLAG(B) RECEIVER(&STRRCV) +
                          SEQ(&ENDSEQ)                                         */ /*BUG7286 CCB020*/
             SCRTVJEVT  EVENT(MPHAS) FLAG(C) RECEIVER(&STRRCV) +
                          SEQ(&ENDSEQ)                                                    /*CCB020*/
/*                                                                                          CSC020*/
/*  Obtain journal entries for this range.                                                  CSC020*/
/*                                                                                          CSC020*/
             DSPJRN     JRN(&JLIB/ICJRN) FILE((MARKTA *ALL) (MARKTD +
                          *ALL) (FOCLTA *ALL) (FOCLTD *ALL) (CHGCMA +
                          *ALL) (CHGCMD *ALL) (INTYPA *ALL) (INTYPD +
                          *ALL) (DEFLTA *ALL) (DEFLTD *ALL) (TRNORA +
                          *ALL) (TRNORD *ALL) (FACKYA *ALL) (FACKYD +
                          *ALL)) RCVRNG(*CURCHAIN) FROMENT(&STRSEQ) +
                          TOENT(&ENDSEQ) ENTTYP(UB UP PT DL DR BR +
                          UR ER) OUTPUT(*OUTFILE) OUTFILE(JRNIMD) +
                          ENTDTALEN(512)                                                  /*CSC020*/
 /*   END OF FIX                                                      /*E15759*/
             MONMSG     MSGID(CPF7062) /* no entries to convert */
 
             ADDLFM     FILE(JRNIM) MBR(JRNIM) SHARE(*YES)
             ADDLFM     FILE(JRNIM1) MBR(JRNIM1) SHARE(*YES)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
/*                                                                  */
