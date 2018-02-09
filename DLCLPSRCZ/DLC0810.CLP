/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Maturing FX Deals Report')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                              */
/*                                                                   */
/*       DLC0810 - FX DEALS MATURITY                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*       1982, 1989                                                  */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      117333             Date 22Sep97              */
/*                      CDL002             DATE 22SEP97              */
/*                      063082             DATE 03FEB94              */
/*                      E27942             DATE 03SEP91              */
/*                      E337               DATE 23APR90              */
/*                      E283               DATE 20MAR90              */
/*                      S01117             DATE 17/07/89             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       117333 - Overrides for DL0683 should also include parent or */
/*                customer number as well as alpha sort key          */
/*       CDL002 - FX Netting. Set Switches U3/U4 for Parent/Customer */
/*                processing                                         */
/*       063082 - Maturing FX deals report (DL0681P1) Should be      */
/*                output in the sequence of customer name and value  */
/*                date.                                              */
/*       E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A       */
/*                LEVEL OF BLANKS                                    */
/*       E337   - CALL DL0681 WITH SEQUENCE NO.                      */
/*       E283   - CHANGE FIELD NAMES TO NEW SYNON NAMES              */
/*                                                                   */
/*       S01117 - RELEASE 10 MULTIBRANCHING, PROGRAM ADDED BY THIS   */
/*                CHANGE                                             */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &OPTN)                 /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&OPTN) TYPE(*CHAR) LEN(1) /* REPORT BY PARENT?  */
   DCL VAR(&RTCD) TYPE(*CHAR) LEN(7)                                  /*CDL002*/
   DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')              /*CDL002*/
 
 
                                                                      /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002')  /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL002) VALUE('Y'))                    /*CDL002*/
                                                                      /*CDL002*/
/*   REPORT BY SYSTEM REQESTED         */
/************IF         COND(&RLEV *EQ 'S')  THEN(DO)                * *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E27942*/
 
/**  CHECK IF PARENT DETAILS REPORT WANTED  */
                IF         COND(&OPTN *EQ 'P')  THEN(DO)
                CHGJOB     SWS(10XXXXXX)
                                                                     /*CDL002*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)               /*CDL002*/
                CHGJOB     SWS(XX10XXXX)                             /*CDL002*/
             ENDDO                                                   /*CDL002*/
                                                                     /*CDL002*/
/* */                                                                /*063082*/
                OVRDBF     FILE(EMDDRP)  TOFILE(EMDDRP)  SHARE(*YES) /*063082*/
                OPNQRYF    FILE((EMDDRP))         +
                                KEYFLD((NAME) (PTNU) (EDAT))         /*063082*/
/* */                                                                /*063082*/
/*              CALL       PGM(DL0681)       */                       /*E337*/
                CALL       PGM(DL0681) PARM(&RSEQ)                    /*E337*/
/* */                                                                /*063082*/
                CLOF       OPNID(EMDDRP)                             /*063082*/
                ENDDO
 
/**  CHECK IF NON-PARENT DETAILS REPORT WANTED  */
                IF         COND(&OPTN *EQ 'N')  THEN(DO)
                CHGJOB     SWS(01XXXXXX)
                                                                     /*CDL002*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)               /*CDL002*/
                CHGJOB     SWS(XX01XXXX)                             /*CDL002*/
             ENDDO                                                   /*CDL002*/
                                                                     /*CDL002*/
/* */                                                                /*063082*/
                OVRDBF     FILE(EMDDRN)  TOFILE(EMDDRN)  SHARE(*YES) /*063082*/
                OPNQRYF    FILE((EMDDRN))  +
                           KEYFLD((NAME) (CUNR) (EDAT))              /*063082*/
/* */                                                                /*063082*/
/*              CALL       PGM(DL0681)       */                       /*E337*/
                CALL       PGM(DL0681) PARM(&RSEQ)                    /*E337*/
/* */                                                                /*063082*/
                CLOF       OPNID(EMDDRN)                             /*063082*/
                ENDDO
             ENDDO
 
 
/*  REPORT BY BRANCH REQUESTED         */
             IF         COND(&RLEV *EQ 'B')  THEN(DO)
 
/**  CHECK IF PARENT DETAILS REPORT WANTED  */
                IF         COND(&OPTN *EQ 'P')  THEN(DO)
                CHGJOB     SWS(10XXXXXX)
                OVRDBF     FILE(EMDDRPQ1) TOFILE(EMDDRP) SHARE(*YES)
/************OPNQRYF    FILE((EMDDRP) (SDCUSTPD)) FORMAT(EMDDRPQ1) +  /*117333*/
/************             KEYFLD((BBBRCD) (PASK) (CASK) (EDAT)) +     /*117333*/
/************             JFLD((EMDDRP/PTNU SDCUSTPD/BBCUST))         /*117333*/
/**                                                                   /*E283*/
/**                       KEYFLD((BBDSNB) (PASK) (CASK) (EDAT)) +   */
/**                       JFLD((EMDDRP/PTNU SDCUSTPD/BBAENB))       */
/**                                                                   /*E283*/
                                                                     /*117333*/
                  OPNQRYF    +
                        FILE((EMDDRP) (SDCUSTPD)) FORMAT(EMDDRPQ1) +
                          KEYFLD((BBBRCD) (PASK) (PTNU) (EDAT)) +
                          JFLD((EMDDRP/PTNU SDCUSTPD/BBCUST))        /*117333*/
                                                                     /*117333*/
                                                                     /*CDL002*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)               /*CDL002*/
                CHGJOB     SWS(XX10XXXX)                             /*CDL002*/
                 OVRDBF     FILE(FXNEVTQ1) TOFILE(FXNEVTLE) +
                              SHARE(*YES)                            /*CDL002*/
                 OPNQRYF    FILE((FXNEVTLE) (SDCUSTPD)) +
                              FORMAT(FXNEVTQ1) KEYFLD((BBBRCD) (PASK) +
                              (PTNU) (EDAT)) JFLD((FXNEVTLE/PTNU +
                              SDCUSTPD/BBCUST))                      /*CDL002*/
                                                                     /*CDL002*/
             ENDDO                                                   /*CDL002*/
                                                                     /*CDL002*/
                CALL       PGM(DL0683) PARM(&RSEQ &RENT)
                CLOF       OPNID(EMDDRP)
                                                                     /*CDL002*/
                CLOF       OPNID(FXNEVTLE)                           /*CDL002*/
                MONMSG     MSGID(CPF4520)                            /*CDL002*/
                                                                     /*CDL002*/
             ENDDO
/**/
/**  CHECK IF NON-PARENT DETAILS REPORT WANTED  */
             IF         COND(&OPTN *EQ 'N')  THEN(DO)
                CHGJOB     SWS(01XXXXXX)
                OVRDBF     FILE(EMDDRNQ1) TOFILE(EMDDRN) SHARE(*YES)
/************OPNQRYF    FILE((EMDDRN) (SDCUSTPD)) FORMAT(EMDDRNQ1) +  /*117333*/
/************             KEYFLD((BBBRCD) (CASK) (EDAT)) +            /*117333*/
/************             JFLD((EMDDRN/CUNR SDCUSTPD/BBCUST))         /*117333*/
/**                                                                   /*E283*/
 /*                       KEYFLD((BBDSNB) (CASK) (EDAT)) +          */
 /*                       JFLD((EMDDRN/CUNR SDCUSTPD/BBAENB))       */
/**                                                                   /*E283*/
                                                                     /*117333*/
             OPNQRYF    FILE((EMDDRN) (SDCUSTPD)) FORMAT(EMDDRNQ1) +
                          KEYFLD((BBBRCD) (CASK) (CUNR) (EDAT)) +
                          JFLD((EMDDRN/CUNR SDCUSTPD/BBCUST))        /*117333*/
                                                                     /*117333*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)               /*CDL002*/
                CHGJOB     SWS(XX01XXXX)                             /*CDL002*/
             OVRDBF     FILE(FXNEVTQ2) TOFILE(FXNEVTLF) SHARE(*YES)  /*CDL002*/
             OPNQRYF    FILE((FXNEVTLF) (SDCUSTPD)) FORMAT(FXNEVTQ2) +
                          KEYFLD((BBBRCD) (CASK) (CUNR) (EDAT)) +
                          JFLD((FXNEVTLF/CUNR SDCUSTPD/BBCUST))      /*CDL002*/
             ENDDO                                                   /*CDL002*/
                                                                     /*CDL002*/
                CALL       PGM(DL0683) PARM(&RSEQ &RENT)
                CLOF       OPNID(EMDDRN)
                                                                     /*CDL002*/
                CLOF       OPNID(FXNEVTLF)                           /*CDL002*/
                MONMSG     MSGID(CPF4520)                            /*CDL002*/
                                                                     /*CDL002*/
                ENDDO
             ENDDO
 
             SNDMSG     MSG('MATURING FX DEALS REPORT') TOMSGQ(MRUNQ)
/************CHGJOB     SWS(00XXXXXX)*/                               /*CDL002*/
             CHGJOB     SWS(0000XXXX)                                 /*CDL002*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
