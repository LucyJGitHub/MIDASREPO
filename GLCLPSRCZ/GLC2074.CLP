/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Accounts enquiries')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     General Ledger Module                             */
/*                                                                   */
/*       GLC2074 - ACCOUNTS ENQUIRIES                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021858           Date 17Aug13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      247699             Date 19Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      222549             Date 06Jun06              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      188467             Date 08Jun01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      117190             Date 11Dec97              */
/*                      092596            DATE  23AUG95             */
/*                      074576            DATE  19AUG94             */
/*                      S01413                  13APR93             */
/*                      S01383                  27APR92             */
/*                      LN0436                  27JUN90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021858 - Reinstate Account Details enquiry option        */
/*       247699 - Ensure that when indicator 05 is on, leave it on  */
/*                as this has been passed from a non-retail screen  */
/*       222549 - 'D0410ACMA' was harcoded into ZMITEM to check the */
/*                Introduced linked enquiry processing in the API   */
/*                version of GL accounts maintenance.               */
/*       CSF002 - Global layer.                                      */
/*                - Replace previous key data with the new unique    */
/*                  code.                                            */
/*       188467 - Rectify badly coded action code validation        */
/*       117190 - Overrides SHARE(*YES) attribute to SHARE(*NO) to  */
/*                avoid 'Open options ignored' message on enquiry   */
/*                screen.                                           */
/*       092596 - Share *NO on SDMMODPD, as GLC3271 also accesses it*/
/*       074576 - GLC3271 needs a parameter for enquiry mode.       */
/*       S01413 - Retail 3 Incorporation.                           */
/*       S01383 - Basic Rate Tax Incorporation                      */
/*       LN0436 - Add Set ON of SWITCH U2 If Retail is in System    */
/*                                                                  */
/********************************************************************/
             PGM                                                      /*S01413*/
/************PGM        PARM(&MODE) */                                /*S01413*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)  */             /*S01413*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*S01383*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01383*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01383')                             /*S01383*/
             DCLF       FILE(SDMMODPD)                                /*LN0436*/
 
 
/**Mode*0*-*Outstanding*Interest*and*Charges**/                       /*S01413*/
/* */                                                                 /*S01413*/
/************IF         COND(&MODE *EQ '0') THEN(CALL PGM(REC0360))*/ /*S01413*/
/* */                                                                 /*S01413*/
/**Modes*2,3*or*4***Accounts*Master*Enquiries**/                      /*S01413*/
/* */                                                                 /*S01413*/
/************ELSE       CMD(DO) */                                    /*S01413*/
/**/                                                                                      /*247699*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)                                  /*247699*/
                CHGJOB     SWS(10001000)                                                  /*247699*/
             ENDDO                                                                        /*247699*/
               ELSE    CMD(DO)                                                            /*247699*/
                CHGJOB     SWS(10000000)
             ENDDO                                                                        /*247699*/
                                                                      /*LN0436*/
/* If Retail Module present set on U2                                   LN0436*/
/**092596**/
             OVRDBF     FILE(SDMMODPD) SHARE(*NO)
/**092596**/
                                                                      /*LN0436*/
                RCVF                                                  /*LN0436*/
/***************IF         COND(&BGRTBN *EQ 'Y') THEN(DO) */ /*LN0436* *S01413*/
                IF         COND(&BGNXST *EQ 'Y') THEN(DO)             /*S01413*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)                                  /*247699*/
                      CHGJOB     SWS(X1XX1XXX)                                            /*247699*/
             ENDDO                                                                        /*247699*/
                ELSE  CMD(DO)                                                             /*247699*/
                      CHGJOB     SWS(X1XXXXXX)                        /*LN0436*/
             ENDDO                                                                        /*247699*/
                ENDDO                                                 /*LN0436*/
/**/                                                                  /*S01383*/
/* DETERMINE IF BRT SAR INSTALLED */                                  /*S01383*/
/**/                                                                  /*S01383*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01383*/
/**/                                                                  /*S01383*/
/* BRT SAR INSTALLED */                                               /*S01383*/
/**/                                                                  /*S01383*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*S01383*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)                                  /*247699*/
                CHGJOB SWS(XX1X1XXX)                                  /*S01383*/          /*247699*/
             ENDDO                                                                        /*247699*/
                ELSE  CMD(DO)                                                             /*247699*/
                CHGJOB SWS(XX1XXXXX)                                  /*S01383*/
             ENDDO                                                                        /*247699*/
             ENDDO                                                    /*S01383*/
/**/                                                                  /*S01383*/
/* CLOSE SCSARDPD FILE            */                                  /*S01383*/
/**/                                                                  /*S01383*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                    /*S01383*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01383*/
 
/***************CALL       PGM(GLOPEN1) PARM('GLOPEN2') */            /*S01413*/
/***************OVRDBF     FILE(MEMO) TOFILE(MEMOS)         */ /*S01413 117190*/
                OVRDBF     FILE(MEMO) TOFILE(MEMOS) SHARE(*NO)        /*117190*/
                OVRDBF     FILE(REACR) SHARE(*NO)                     /*117190*/
                OVRDBF     FILE(REIAC) SHARE(*NO)                     /*117190*/
                OVRDBF     FILE(REDEF) SHARE(*NO)                     /*117190*/
                OVRDBF     FILE(RECRG) SHARE(*NO)                     /*117190*/
/*/COPY WNCPYSRC,GLC2074001                                          */
                CALL       PGM(GLOPEN1)                               /*S01413*/
 
/**Set*up*LDA*for*GLINPUT*and*GL0271**/                               /*S01413*/
/* */                                                                 /*S01413*/
/***************CHGDTAARA  DTAARA(LDA (1 8)) VALUE('GL0271  ') */     /*S01413*/
/***************CHGDTAARA  DTAARA(LDA (132 1)) VALUE(&MODE)    */     /*S01413*/
 
/* Call enquiry */
 
/***************CALL       PGM(GLINPUT) */                            /*S01413*/
/***************CALL       PGM(GLC3271)                    /*S01413*/ /*074576*/
                CRTDUPOBJ OBJ(ZMITEM) FROMLIB(QTEMP) OBJTYPE(*DTAARA) +
                          TOLIB(QTEMP) NEWOBJ(#ZMITEM)                /*188467*/
/**********     CHGDTAARA  DTAARA(QTEMP/ZMITEM) VALUE('D0410ACMA')                 /*188467 CSF002*/
/**********     CHGDTAARA  DTAARA(QTEMP/ZMITEM) VALUE('0000000422')              /*CSF002 MD021858*/
                CHGDTAARA  DTAARA(QTEMP/ZMITEM) VALUE('0000000424')                     /*MD021858*/
/**********     CALL       PGM(GLC3271) PARM('E')                                  /*074576 222549*/
                CALL       PGM(GLC1) PARM('GLAMADSIN')                                    /*222549*/
                DLTDTAARA  DTAARA(QTEMP/ZMITEM)                       /*188467*/
                RNMOBJ     OBJ(QTEMP/#ZMITEM) OBJTYPE(*DTAARA) +
                          NEWOBJ(ZMITEM)                              /*188467*/
                RCLRSC
 
/************ENDDO */                                                 /*S01413*/
                DLTOVR     FILE(MEMO)                                 /*S01413*/
                DLTOVR     FILE(REACR REIAC REDEF RECRG)              /*117190*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
