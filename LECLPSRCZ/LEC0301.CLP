/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE OUTSTNDING FACLTIES BY CUSTOMER')            */
/********************************************************************/
/*                                                                  */
/*        Midas - Customer Lending Module                       */
/*                                                                  */
/*        LEC0301-OUTSTANDING FACILITIES BY CUSTOMER ENQUIRY        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 122657             Date 05Sep97              */
/*                      CLE004             Date 02Dec96              */
/*                      S01408            Date  20Jun95             */
/*                      S01473            DATE  28JUL94             */
/*                      S01311            DATE  22FEB91             */
/*                      S01194            DATE  08FEB90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       122657 - Override to Facility File                         */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
/*       S01408 - Addition of core hooks LEC0301MP1                 */
/*                                       LEC0301MP2                 */
/*       S01473 - Midas Leo Integration.                            */
/*                Addition of processing to display LC information  */
/*                related to a customer facility.                   */
/*       S01311 - EXPOSURE MANAGEMENT ENQUIRIES                     */
/*                LE0160 REWRITTEN AND REPLACED BY LE0161           */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
                                                                      /*S01473*/
/* Declare the variables to check the enhancements file */            /*S01473*/
     DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                         /*S01473*/
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*S01473*/
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473')         /*S01473*/
     DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                        /*S01473*/
     DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)                       /*S01473*/
     DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1)                       /*CLE004*/
     DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(2)                       /*S01473*/
     DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                      /*S01473*/
     DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)                       /*S01473*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                      /*S01473*/
/* Access switchable features file to see if feature S01473     */    /*S01473*/
/* is installed  */                                                   /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*S01473*/
/**/                                                                  /*CLE004*/
/* Determine if CLE004 is installed                                */ /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&SARD) VALUE('CLE004')                    /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*CLE004*/
                                                                      /*S01473*/
/* If feature S01473 is installed, setup LEO Libraries  */            /*S01473*/
             IF         COND(&S01473 *EQ 'Y') THEN(DO)                /*S01473*/
             RTVDTAARA  DTAARA(LOPREF) RTNVAR(&DTAARA)                /*S01473*/
                                                                      /*S01473*/
/* If either position is blank, this is an error */                   /*S01473*/
             IF         COND((%SST(&DTAARA 1 1) *EQ ' ') *OR +
                          (%SST(&DTAARA 2 1) *EQ ' ')) THEN(DO)       /*S01473*/
             CHGJOB     SWS(XXXXXXX1)                                 /*S01473*/
             GOTO       CMDLBL(ERROR)                                 /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             CHGVAR     VAR(&DMLIB) VALUE(&DTAARA *CAT 'DMLIB')       /*S01473*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0301MP2                                     */    /*S01408*/
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&LDLIB) VALUE(&DTAARA *CAT 'LDLIB')       /*S01473*/
             CHGVAR     VAR(&DTALIB) VALUE(&DTAARA *CAT 'DTALIB')     /*S01473*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0301MP1                                     */    /*S01408*/
/**/                                                                  /*S01408*/
             OVRDBF     FILE(FDRAW) TOFILE(&LDLIB/FDRAW)              /*S01473*/
             OVRDBF     FILE(TBCCY) TOFILE(&DMLIB/TBCCY)              /*S01473*/
             OVRDBF     FILE(TBSC) TOFILE(&DMLIB/TBSC)                /*S01473*/
             OVRDBF     FILE(TBPCL) TOFILE(&DMLIB/TBPCL)              /*S01473*/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&DTALIB/CMSG03)         /*S01473*/
                                                                      /*S01473*/
/* Retrieve Library for program CLCD42   */                           /*S01473*/
             CHGVAR     VAR(&PARM1) VALUE('CLCD42FM')                 /*S01473*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*S01473*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*S01473*/
             OVRDBF     FILE(CLCD42FM) TOFILE(&PARM2/CLCD42FM)        /*S01473*/
             CHGDTAARA  DTAARA(*LDA (51 974)) VALUE(' ')              /*S01473*/
                                                                      /*S01473*/
/* Retrieve Library for program CLCD42   */                           /*S01473*/
             CHGVAR     VAR(&PARM1) VALUE('CLCD42')                   /*S01473*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*S01473*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*S01473*/
/************CHGVAR     VAR(%SUBSTRING(*LDA 61 10)) VALUE(&PARM2)***/ /*S01473*/
             CHGVAR     VAR(%SUBSTRING(*LDA 81 10)) VALUE(&PARM2)     /*S01473*/
                                                                      /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/**/                                                                  /*CLE004*/
/* If CLE004 is installed, files should not share access paths     */ /*CLE004*/
/**/                                                                  /*CLE004*/
             IF         COND(&CLE004 *EQ 'Y') THEN(DO)                /*CLE004*/
                OVRDBF     FILE(LOAMS) SHARE(*NO)                     /*CLE004*/
             ENDDO                                                    /*CLE004*/
                                                                     /*S01311*/
/************CALL       PGM(LE0160)                                  /*S01311*/
             OVRDBF     FILE(FCLTY) SHARE(*NO)                        /*122657*/
             CALL       PGM(LE0161)                                  /*S01311*/
                                                                     /*S01311*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
ERROR:                                                                /*S01473*/
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                              /*S01473*/
                                                                      /*S01473*/
            SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                       TOMSGQ(MOPERQ MRUNQ)                           /*S01473*/
                                                                      /*S01473*/
     ENDDO                                                            /*S01473*/
             DLTOVR     FILE(*ALL)                                    /*S01473*/
/************CHGDTAARA  DTAARA(*LDA (51 20)) VALUE(' ')*************/ /*S01473*/
             CHGDTAARA  DTAARA(*LDA (81 10)) VALUE(' ')               /*S01473*/
                                                                      /*S01473*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
