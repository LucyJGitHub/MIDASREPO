/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ED Bulk CL copy component')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas Export Data Interface Module                  */
/*                                                                   */
/*       EDC0027 - Bulk Transfer Format Copy Component               */
/*                                                                   */
/*       Function : This program copies data into PF/EDBULKPD. This  */
/*                  file will already have been overridden to the    */
/*                  correct member                                   */
/*                                                                   */
/*       Called by: ED0020                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      121889             Date 15Aug97              */
/*                      CED004             Date 30JUN97              */
/*                      CAA012             Date 12DEC96              */
/*                      103143             DATE 05JUN96              */
/*                      S01493 *CREATE     DATE 16MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       121889 - Add an extra input parameter to allow special      */
/*                processing programs to use this program to         */
/*                update the batch member text.                      */
/*       CED004 - EXCLUDE REGULAR PAYMENTS FOR FT                   */
/*                ONLY TAKE AUTHORISED OPS AND INS                  */
/*       CAA012 - Enhancemnts to export function: this program       */
/*                changed so as to always copy parent records before */
/*                children on SDCUSTPD.  This eases import into DTA. */
/*                Also, include useful info on batch member text.    */
/*       103143 - REVIEW COPY PROCESS FOR BULK TRANSFER              */
/*       S01493 - Midas Export Data Interface Module                 */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FILENM &MEMBNM &BTCHNM &STARTR &ENDR +  /*103143*/
/**********               &RTCD)                                      /*103143*/
/**********  PGM        PARM(&FILENM &MEMBNM &BTCHNM &STARTR &ENDR +
/**********               &RTCD &COUNT)                    /*103143*/ /*121889*/
             PGM        PARM(&FILENM &MEMBNM &BTCHNM &STARTR &ENDR +
                          &RTCD &COUNT &SPP)                          /*121889*/
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&FILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTCHNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STARTR) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&ENDR) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&STARTRM1)  TYPE(*DEC) LEN(9 0)           /*CED004*/
             DCL        VAR(&NREC) TYPE(*DEC) LEN(9 0)                /*CED004*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)              /*103143*/
             DCL        VAR(&COUNTALPHA) TYPE(*CHAR) LEN(10)          /*CAA012*/
             DCL        VAR(&MBRTEXT) TYPE(*CHAR) LEN(30)             /*CAA012*/
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(7)                 /*CAA012*/
             DCL        VAR(&SPP) TYPE(*CHAR) LEN(1)                  /*121889*/
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&STARTRM1) VALUE(&STARTR - 1 )           /*CED004*/
             CHGVAR     VAR(&NREC) VALUE(&ENDR - &STARTRM1)          /*CED004*/
 
/* Copy file */
 
/** +
    Override changed to ensure that ODPs are shared, as OPNQRYF is  +
    being used.                                              /*CAA012 +
**/
/************OVRDBF     FILE(&FILENM) SEQONLY(*YES)  ***/    /*CAA012*/
             OVRDBF     FILE(&FILENM) SHARE(*YES) SEQONLY(*YES)
                                                             /*CAA012*/
                                                                      /*103143*/
/* If the calling program is a special processing program then */     /*121889*/
/* only perform the member text update.                        */     /*121889*/
 
             IF         COND(&SPP *NE ' ') +
                          THEN(GOTO CMDLBL(UPDMEMBER))                /*121889*/
 
             IF         COND(%SUBSTRING(&FILENM 1 5) = 'DEALS') +
                          THEN(DO)                                    /*103143*/
                CPYF       FROMFILE(&FILENM) TOFILE(EDBULKPD) +
                             FROMMBR(&MEMBNM) TOMBR(&BTCHNM) +
                             MBROPT(*ADD) FROMRCD(&STARTR) +
                             TORCD(&ENDR) INCREL((*IF RECI *NE 'N')) +
                             FMTOPT(*NOCHK)                           /*103143*/
                                                                      /*103143*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(EDBULKPD) MBR(&BTCHNM))                /*103143*/
             ENDDO                                                    /*103143*/
             ELSE       CMD(DO)                                       /*103143*/
/** +
    Special processing for the customers file: the batch needs to be +
    ordered with parents before children, to ease import into DTA.   +
    OPNQRYF is used to create a temporary key.               /*CAA012 +
**/
                IF         COND(&FILENM *EQ 'SDCUSTPD') THEN(DO) +
                                                             /*CAA012*/
 
                   OPNQRYF    FILE((&FILENM &MEMBNM)) KEYFLD((BBPAIN +
                                *DESCEND)) /*CAA012*/
                   CPYFRMQRYF FROMOPNID(&FILENM) TOFILE(EDBULKPD) +
                                TOMBR(&BTCHNM) MBROPT(*ADD) +
                                NBRRCDS(&ENDR) FMTOPT(*NOCHK) +
                                                             /*CAA012*/
                   CLOF       OPNID(SDCUSTPD)                /*CAA012*/
 
                ENDDO                                        /*CAA012*/
 
                ELSE       CMD(DO)                           /*CAA012*/
                                                                      /*CED004*/
                IF         COND(&FILENM *EQ 'OTPAYDD') THEN(DO) +
                                                                      /*CED004*/
                   /* Select Live Authorised Outgoing Payments        *CED004*/
                   OPNQRYF    FILE((&FILENM &MEMBNM)) QRYSLT('RECI="D" +
                          *AND PYTP *EQ "OP" *AND AUIN *EQ "Y"')      /*CED004*/
                                                                      /*CED004*/
                   /* IGNORE RECORDS TO STARTR BUT SET POINTER       CED004*/
                   IF COND(&STARTRM1 *GT 0) THEN(DO)               /*CED004*/
                   CPYFRMQRYF FROMOPNID(&FILENM) TOFILE(QTEMP/XXX) +
                          TOMBR(*FIRST) MBROPT(*REPLACE) +
                          CRTFILE(*YES) NBRRCDS(&STARTRM1) +
                          FMTOPT(*NOCHK)                              /*CED004*/
                   ENDDO                                         /*CED004*/
                   /* ADD NEXT SET OF RECORDS TO THE BATCH           CED004*/
                   IF COND(&NREC *GT 0) THEN(DO)                  /*CED004*/
                   CPYFRMQRYF FROMOPNID(&FILENM) TOFILE(EDBULKPD) +
                          TOMBR(&BTCHNM) MBROPT(*ADD) +
                          NBRRCDS(&NREC) FMTOPT(*NOCHK)               /*CED004*/
                   CLOF    OPNID(&FILENM)                          /*CED004*/
                   ENDDO                                              /*CED004*/
                                                                      /*CED004*/
                ENDDO                                                 /*CED004*/
                                                                      /*CED004*/
                ELSE       CMD(DO)                                    /*CED004*/
                                                                      /*CED004*/
                IF         COND(&FILENM *EQ 'INPAYDD') THEN(DO) +
                                                                      /*CED004*/
                   /*  Select Live Authorised INCOMING Payments         CED004*/
                   OPNQRYF FILE((&FILENM &MEMBNM)) QRYSLT('RECI="D" *AND PYTP +
                          *EQ "IN" *AND AUIN *EQ "Y"')
                   /*  IGNORE RECORDS TO STARTR BUT SET POINTER        *CED004*/
                   IF   COND(&STARTRM1 *GT 0) THEN(DO)                /*CED004*/
                   CPYFRMQRYF FROMOPNID(&FILENM) TOFILE(QTEMP/XXX) +
                          TOMBR(*FIRST) MBROPT(*REPLACE) +
                          CRTFILE(*YES) NBRRCDS(&STARTRM1) +
                          FMTOPT(*NOCHK)                              /*CED004*/
                   ENDDO                                         /*CED004*/
                   /* ADD NEXT SET OF RECORDS TO THE BATCH         CED004*/
                   IF         COND(&NREC *GT 0) THEN(DO)              /*CED004*/
                   CPYFRMQRYF FROMOPNID(&FILENM) TOFILE(EDBULKPD) +
                          TOMBR(&BTCHNM) MBROPT(*ADD) +
                          NBRRCDS(&NREC) FMTOPT(*NOCHK)               /*CED004*/
                   CLOF       OPNID(&FILENM)                          /*CED004*/
                   ENDDO                                              /*CED004*/
                                                                      /*CED004*/
                ENDDO                                                 /*CED004*/
                                                                      /*CED004*/
                ELSE       CMD(DO)                                    /*CED004*/
                                                                      /*103143*/
                   CPYF       FROMFILE(&FILENM) TOFILE(EDBULKPD) +
                                FROMMBR(&MEMBNM) TOMBR(&BTCHNM) +
                                MBROPT(*ADD) FROMRCD(&STARTR) +
                                TORCD(&ENDR) FMTOPT(*NOCHK)
 
/**********     MONMSG     MSGID(CPF1011)                             /*103143*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(EDBULKPD) MBR(&BTCHNM))             /*103143*/
 
                ENDDO                                        /*INPAY CED004*/
                ENDDO                                        /*OTPAY CED004*/
 
                ENDDO                                        /*CAA012*/
 
             ENDDO                                                    /*103143*/
                                                                      /*103143*/
 UPDMEMBER:                                                           /*121889*/
 
/* Retrieve number of records in the batch */                         /*103143*/
                                                                      /*103143*/
             CHGVAR     VAR(&COUNT) VALUE(0)                          /*103143*/
                                                                      /*103143*/
             RTVMBRD    FILE(EDBULKPD) MBR(&BTCHNM) NBRCURRCD(&COUNT) /*103143*/
                                                                      /*CAA012*/
/* Update member text to reflect no. records, file and run date */    /*CAA012*/
                                                                      /*CAA012*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)            /*CAA012*/
             CHGVAR     VAR(&COUNTALPHA) VALUE(&COUNT)                /*CAA012*/
             CHGVAR     VAR(&MBRTEXT) VALUE(&COUNTALPHA *CAT ' ' *CAT +
                          &FILENM *CAT ' ' *CAT &DATE)                /*CAA012*/
             CHGPFM     FILE(EDBULKPD) MBR(&BTCHNM) TEXT(&MBRTEXT)    /*CAA012*/
                                                                      /*103143*/
             DLTOVR     FILE(&FILENM)
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination */
 
ABNOR:
 
             CLOF       OPNID(SDCUSTPD)                      /*CAA012*/
             MONMSG     MSGID(CPF0000 MCH0000)               /*CAA012*/
             CLOF       OPNID(&FILENM )                      /*CED004*/
             MONMSG     MSGID(CPF0000 MCH0000)               /*CED004*/
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RTCD) VALUE('E')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS('XXXXXX11')
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
