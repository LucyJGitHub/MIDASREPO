/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE OUTSTNDING DELIVERY INSTRUCTIONS')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0707 -OUTSTANDING DELIVERY INSTRUCTIONS                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CLE175             Date 07Aug23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194             Date 11Dec89              */
/*                      S01117             Date 11Dec89              */
/*                                                                  */
/********************************************************************/
/*       CLE175 - Exclude LE Interbranch Entries from Outstanding    */
/*                 Deal Report                                       */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('OUTSTANDING DELIVERY INSTRUCTIONS')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE175*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CLE175*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CLE175*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CLE175*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE175*/
             DCL        VAR(&CLE175) TYPE(*CHAR) LEN(1)                                   /*CLE175*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*PRINT                                                             */
             CHGJOB     SWS(XXXXXX00)
/**/                                                                                      /*CLE175*/
/** Access SAR file to determine if switchable feature CLE175     */                      /*CLE175*/
/** is switched ON.  If ON, override to new LF LVEDEV0            */                      /*CLE175*/
/**/                                                                                      /*CLE175*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE175*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE175*/
             CHGVAR     VAR(&SAR) VALUE('CLE175')                                         /*CLE175*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE175*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE175) VALUE('Y'))                                        /*CLE175*/
                                                                                          /*CLE175*/
/************OVRDBF     FILE(TABLE) TOFILE(TABLEEE)           */      /*S01194*/
/**/
/************CALL       PGM(LE0620)                               */  /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/

             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(LVEDE) POSITION(*KEY 1 LVENTELF +
                           &RENT)                                     /*S01117*/
                                                                                          /*CLE175*/
 /*CLE175 - OVERRIDE DONE IN HERE TO AFFECT THE OPNDBF */                                 /*CLE175*/
                 IF        COND(&CLE175 = 'Y') THEN(OVRDBF FILE(LVEDE) +
                           TOFILE(LVEDEV0) POSITION(*KEY 1 LVENTELF +
                           &RENT))                                                        /*CLE175*/
                                                                                          /*CLE175*/
                 OPNDBF    FILE(LVEDE) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(LVEDE)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE DO                                                                      /*CLE175*/
 /* CLE175 - Do Override here if &RENT EQ ALL  */                                         /*CLE175*/
                 IF        COND(&CLE175 = 'Y') THEN(OVRDBF FILE(LVEDE) +
                           TOFILE(LVEDEV0))                                               /*CLE175*/
             ENDDO                                                                        /*CLE175*/
                                                                                          /*CLE175*/
             CALL       PGM(LE0620) PARM(&RSEQ &RENT)                 /*S01117*/
/**/
/************DLTOVR     FILE(TABLE)                     */            /*S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
