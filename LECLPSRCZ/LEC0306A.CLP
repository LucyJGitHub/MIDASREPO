/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Matured Loan Activity Enquiry')              */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LEC0306A - Matured Loan Activity Enquiry                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 260601             Date 04Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG12979           Date 28Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      190005             Date 23Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      128954             Date 17Feb98              */
/*                      S01408             Date 03May96              */
/*                                                                  */
/********************************************************************/
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       260601 - Matured loans can't be enquired on option MLON.    */
/*                Add override to MLOAN to see matured loans.        */
/*       BUG12979 - Display matured loan details                    */
/*       190005 - Change screen heading from 'LOANS ACTIVITY ENQUIRY'*/
/*                to 'MATURED LOANS ENQUIRY'.                        */
/*       128954 - Call new program LE0212 instead of LE0210 if      */
/*                CLE004 is installed                               */
/*       S01408 - Addition of core hook LEC0306A02                  */
/*                Addition of core hook LEC0306A01                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)        /*128954*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                   /*128954*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE004')                    /*128954*/
/**/                                                         /*128954*/
/* Determine if CLE004 installed  */                         /*128954*/
/**/                                                         /*128954*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)    /*128954*/
/**/                                                         /*128954*/
/* Error */                                                  /*128954*/
/**/                                                         /*128954*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                /*128954*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)               /*128954*/
             CHGJOB (XXXXXX11)                               /*128954*/
             GOTO       CMDLBL(EXIT)                         /*128954*/
             ENDDO                                           /*128954*/
/**/
/**********  OVRDBF     FILE(CLOAN) TOFILE(MLOAN) */                                    /*BUG12979*/
             OVRDBF     FILE(CLOAN) TOFILE(MLOAN)                                         /*260601*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0306A01                                          */
                                                                     /*S01408*/
             OVRDBF     FILE(HISTR) TOFILE(MHISR)
/**/
             CHGJOB     SWS(1XXXXXXX)                                                     /*190005*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(LE0212))                       /*128954*/
             ELSE       CMD(DO)                              /*128954*/
             CALL       PGM(LE0210)
             ENDDO                                           /*128954*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0306A02                                          */
                                                                     /*S01408*/
/**/
/**********  DLTOVR     FILE(CLOAN HISTR) */                                            /*BUG12979*/
             DLTOVR     FILE(*ALL)                                                        /*260601*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
EXIT:                                                        /*128954*/
             ENDPGM
