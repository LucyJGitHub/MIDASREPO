/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE CUSTOMER PORTFOLIO')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*             LEC0305-CUSTOMER PORTFOLIO ENQUIRY                   */
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
/*       Prev Amend No. 131623             Date 29May98              */
/*                      CLE004             Date 02Dec96              */
/*                      S01311             Date 22Feb91              */
/*                      S01194             Date 08Feb90              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       131623 - Pattern LEC0305 from LEC0301 where amendments was */
/*                done to accomodate CAR S01473.  The said CAR      */
/*                covers: Midas Leo Integration.  This would be used*/
/*                to display LC information related to a customer   */
/*                facility.                                         */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
/*       S01311 - EXPOSURE MANAGEMENT ENQUIRIES                     */
/*                LE0200 REWRITTEN AND REPLACED BY LE0201           */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE004*/
/************DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)           /*CLE004131623*/
/************DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)           /*CLE004131623*/
/**/
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*131623*/
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473')         /*131623*/
/**/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CLE004*/
/**/
     DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)                       /*131623*/
     DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(2)                       /*131623*/
     DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)                       /*131623*/
     DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(10)                       /*131623*/
     DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                      /*131623*/
     DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)                       /*131623*/
     DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)                       /*131623*/
/**/                                                                  /*131623*/
/**********  OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEIC) SHARE(*NO)      * *S01194*/
/**/                                                                  /*131623*/
                                                                      /*131623*/
/* Access switchable features file to see if feature S01473     */    /*131623*/
/* is installed  */                                                   /*131623*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*131623*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*131623*/
                                                                      /*131623*/
/* If feature S01473 is installed, setup LEO Libraries  */            /*131623*/
             IF         COND(&S01473 *EQ 'Y') THEN(DO)                /*131623*/
             RTVDTAARA  DTAARA(LOPREF) RTNVAR(&DTAARA)                /*131623*/
                                                                      /*131623*/
/* If either position is blank, this is an error */                   /*131623*/
             IF         COND((%SST(&DTAARA 1 1) *EQ ' ') *OR +
                          (%SST(&DTAARA 2 1) *EQ ' ')) THEN(DO)       /*131623*/
             CHGJOB     SWS(XXXXXXX1)                                 /*131623*/
             GOTO       CMDLBL(ERROR)                                 /*131623*/
             ENDDO                                                    /*131623*/
                                                                      /*131623*/
             CHGVAR     VAR(&DMLIB) VALUE(&DTAARA *CAT 'DMLIB')       /*131623*/
             CHGVAR     VAR(&LDLIB) VALUE(&DTAARA *CAT 'LDLIB')       /*131623*/
             CHGVAR     VAR(&DTALIB) VALUE(&DTAARA *CAT 'DTALIB')     /*131623*/
             OVRDBF     FILE(FDRAW) TOFILE(&LDLIB/FDRAW)              /*131623*/
             OVRDBF     FILE(TBCCY) TOFILE(&DMLIB/TBCCY)              /*131623*/
             OVRDBF     FILE(TBSC) TOFILE(&DMLIB/TBSC)                /*131623*/
             OVRDBF     FILE(TBPCL) TOFILE(&DMLIB/TBPCL)              /*131623*/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&DTALIB/CMSG03)         /*131623*/
                                                                      /*131623*/
/* Retrieve Library for program CLCD42   */                           /*131623*/
             CHGVAR     VAR(&PARM1) VALUE('CLCD42FM')                 /*131623*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*131623*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*131623*/
             OVRDBF     FILE(CLCD42FM) TOFILE(&PARM2/CLCD42FM)        /*131623*/
             CHGDTAARA  DTAARA(*LDA (51 974)) VALUE(' ')              /*131623*/
                                                                      /*131623*/
/* Retrieve Library for program CLCD42   */                           /*131623*/
             CHGVAR     VAR(&PARM1) VALUE('CLCD42')                   /*131623*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*131623*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*131623*/
             CHGVAR     VAR(%SUBSTRING(*LDA 81 10)) VALUE(&PARM2)     /*131623*/
                                                                      /*131623*/
             ENDDO                                                    /*131623*/
/**/                                                                  /*CLE004*/
/* If SAR CLE004 is installed, files should not share access paths */ /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SARD) VALUE('CLE004')                    /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE004*/
                OVRDBF     FILE(LOAMS) SHARE(*NO)                     /*CLE004*/
             ENDDO                                                    /*CLE004*/
                                                                     /*S01311*/
/************CALL       PGM(LE0200)                                   *S01311*/
             CALL       PGM(LE0201)                                  /*S01311*/
                                                                     /*S01311*/
/**/                                                                 /*131623*/
ERROR:                                                               /*131623*/
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                             /*131623*/
                                                                     /*131623*/
            SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                       TOMSGQ(MOPERQ MRUNQ)                          /*131623*/
                                                                     /*131623*/
     ENDDO                                                           /*131623*/
             CHGDTAARA  DTAARA(*LDA (81 10)) VALUE(' ')              /*131623*/
             DLTOVR     FILE(*ALL)                                   /*131623*/
/**/                                                                 /*131623*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
