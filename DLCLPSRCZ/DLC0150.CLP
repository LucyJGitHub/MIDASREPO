/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Open Query for Ccy Posns. Enq.')             */
/********************************************************************/
/*                                                                  */
/*       Midas     - DEALING MODULE                             */
/*                                                                  */
/*       DLC0150 - CURRENCY POSITIONS ENQUIRY                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 30Aug00              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      180788             Date 30Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU012             Date 16Feb98              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       180788 - Allow more than one user to access the Foreign     */
/*                Currency Positions Enquiry screen at the same time.*/
/*                Applied fixes 149887 and 177434.                   */
/*       CEU012 - EMU Position/Risk Enquiries                        */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   Branch And Company Codes                                       */
             PGM        PARM(&BRC &CMP)
/*                                                                  */
/*   Declare Program Variable                                       */
             DCL        VAR(&BRC) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CMP) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(35)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU012*/
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(1)               /*CEU012*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*CEU012*/
/* Check if CEU012 is installed */                                    /*CEU012*/
/**/                                                                  /*CEU012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU012*/
             CHGVAR     VAR(&SARD) VALUE('CEU012')                    /*CEU012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CEU012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU012) VALUE('Y'))                    /*CEU012*/
/**/                                                                  /*CEU012*/
/* Error */                                                           /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU012*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU012*/
                CHGJOB (XXXXXX11)                                     /*CEU012*/
                GOTO       CMDLBL(END)                                /*CEU012*/
             ENDDO                                                    /*CEU012*/
/*                                                                  */
             CHGVAR     VAR(&SELECT) VALUE(*BLANK)
/**/                                                                  /*CEU012*/
/*   EMU Position/Risk Enq. & Rep feature changes                  */ /*CEU012*/
             IF         COND(&CEU012 *EQ 'Y') THEN(DO)                /*CEU012*/
/***********    OVRDBF     FILE(GLOLPEL1) SHARE(*YES)  ***/    /*CEU012 180788*/
                OVRDBF     FILE(GLOLPEL1) TOFILE(OLPOS4) +
                             SHARE(*YES)                              /*180788*/
                OVRDBF     FILE(GLOLPEL2) TOFILE(OLPOS5) +
                             SHARE(*YES)                              /*180788*/
/***********    CLOF       GLOLPEL1   ***/                     /*CEU012 180788*/
                CLOF       OLPOS4                                     /*180788*/
                MONMSG     MSGID(CPF0000)                      /*CEU012 180788*/
                CLOF       OLPOS5                                     /*180788*/
                MONMSG     MSGID(CPF0000)                             /*CEU012*/
/**/                                                                  /*CEU012*/
/*   Build Open Query File For Branch Sent To Program              */ /*CEU012*/
                IF         COND(&BRC *NE '   ') THEN(DO)              /*CEU012*/
/***********       CHGVAR     VAR(%SST(&SELECT 001 030)) VALUE('BRCA *EQ +
                             "'****&BRC****'" ') ***/                 /*CEU012 BG18886*/
                   CHGVAR     VAR(%SST(&SELECT 001 030)) VALUE('BRCA *EQ +
                             "' *CAT &BRC *CAT '" ')                  /*CEU012 BG18886*/
/***********       OPNQRYF    FILE((GLOLPEL1 *FIRST GLOLEMD0)) +
                             QRYSLT(&SELECT)   ***/            /*CEU012 180788*/
                   OPNQRYF    FILE((OLPOS4  *FIRST GLOP1)) FORMAT(GLOLPEL1 +
                             GLOLEMD0) QRYSLT(&SELECT)                /*180788*/
                ENDDO                                                 /*CEU012*/
/*                                                                 */ /*CEU012*/
/*   Build Open Query File For Company Sent To Program             */ /*CEU012*/
                IF         COND(&CMP *NE '   ') THEN(DO)              /*CEU012*/
/***********       CHGVAR     VAR(%SST(&SELECT 001 031)) VALUE('CMPYM *EQ +
                           "'****&CMP****'" ') ***/                   /*CEU012 BG18886*/
                   CHGVAR     VAR(%SST(&SELECT 001 031)) VALUE('CMPYM *EQ +
                           "' *CAT &CMP *CAT '" ')                    /*CEU012 BG18886*/
/***********       OPNQRYF    FILE((GLOLPEL1 *FIRST GLOLEMD0)) +
                           QRYSLT(&SELECT)   ***/              /*CEU012 180788*/
                   OPNQRYF    FILE((OLPOS5  *FIRST GLOP1)) FORMAT(GLOLPEL1 +
                           GLOLEMD0) QRYSLT(&SELECT)                  /*180788*/
                ENDDO                                                 /*CEU012*/
             ENDDO                                                    /*CEU012*/
/*                                                                  */
             OVRDBF     FILE(OLPOS1) SHARE(*YES)
             CLOF       OLPOS1
             MONMSG     MSGID(CPF0000)
/*                                                                  */
/*   Build Open Query File For Branch Sent To Program               */
             IF         COND(&BRC *NE '   ') THEN(DO)
/**********  CHGVAR     VAR(%SST(&SELECT 001 030)) VALUE('BRCA *EQ "' +
                          ***&BRC****'" ')   ***/                     /*BG18886*/
             CHGVAR     VAR(%SST(&SELECT 001 030)) VALUE('BRCA *EQ "' +
                          *CAT &BRC *CAT '" ')                        /*BG18886*/
             OPNQRYF    FILE((OLPOS1 *FIRST OLPOSOAF)) QRYSLT(&SELECT)
             ENDDO
/*                                                                  */
/*   Build Open Query File For Company Sent To Program               */
             IF         COND(&CMP *NE '   ') THEN(DO)
/**********  CHGVAR     VAR(%SST(&SELECT 001 031)) VALUE('CMPYM *EQ +
                          "'****&CMP****'" ')   ***/                  /*BG18886*/
             CHGVAR     VAR(%SST(&SELECT 001 031)) VALUE('CMPYM *EQ +
                          "' *CAT &CMP *CAT '" ')                     /*BG18886*/
             OPNQRYF    FILE((OLPOS1 *FIRST OLPOSOAF)) QRYSLT(&SELECT)
             ENDDO
/*                                                                  */
/*   Return To Called Program                                       */
             RETURN
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
