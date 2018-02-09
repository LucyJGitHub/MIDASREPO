/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT RFT / CCT list / audit report (COB)')        */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0232    NON-AUTHORISED PAYMENTS                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 226942             Date 21May04              */
/*                      221652             Date 22Jan04              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207984             Date 31Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT008             Date 04Jan00              */
/*                      CFT006             Date 10Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       226942 - Make RFT/CCT Authorised/Unauthorised reports       */
/*                available in the system.                           */
/*       221652 - Make report request available in the system.       */
/*       207984 - Initialise &SARD before calling AOSARDR0.          */
/*       CFT008 - Funds Transfer/Swift Messages MT102                */
/*       CFT006 - Funds Transfer/Swift Messages MT101                */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                                     /*221652*/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)                                     /*221652*/
 
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
        DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                     VALUE('CFT006')
        DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
        DCL        VAR(&SARD1) TYPE(*CHAR) LEN(6) +
                     VALUE('CFT008')                                 /*CFT008*/
        DCL        VAR(&RTCD1) TYPE(*CHAR) LEN(7)                    /*CFT008*/
        DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
        DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2)                                          /*221652*/
/*******DCL        VAR(&PBRCA) TYPE(*CHAR) LEN(3) */                               /*221652 226942*/
        DCL        VAR(&STRT) TYPE(*DEC) LEN(5 0)                                         /*221652*/
        DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0)                                         /*221652*/
        DCL        VAR(&PMENU) TYPE(*CHAR) LEN(3)                                         /*226942*/
        DCL        VAR(&RNTP) TYPE(*CHAR) LEN(1)                                          /*221652*/
        DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)                                        /*221652*/
/**/
        SNDPGMMSG MSG('FT0230 - RFT / CCT LIST report') +
             TOMSGQ(MRUNQ)
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB SWS(00000000)
/**/
        CHGVAR     VAR(&RNTP) VALUE(%SST(&PARM 4 1))                                      /*221652*/
        CHGVAR     VAR(&PTYP) VALUE(%SST(&PARM 5 2))                                      /*221652*/
/*******CHGVAR     VAR(&PBRCA) VALUE(%SST(&PARM 7 3)) */                           /*221652 226942*/
        CHGVAR     VAR(&STRT) VALUE(%SST(&PARM 10 5))                                     /*221652*/
        CHGVAR     VAR(&ENDT) VALUE(%SST(&PARM 15 5))                                     /*221652*/
        CHGVAR     VAR(&PMENU) VALUE(%SST(&PARM 20 3))                                    /*226942*/
/**/                                                                                      /*221652*/
/** RFT / CCT LIST REPORT **/
/**/
             CHGVAR     VAR(&SARD) VALUE('CFT006')                                        /*207984*/
        CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
        IF     COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
        ENDDO
             CHGVAR     VAR(&SARD1) VALUE('CFT008')                                       /*207984*/
                                                                     /*CFT008*/
        CALL       PGM(AOSARDR0) PARM(&RTCD1 &OPTN &SARD1)           /*CFT008*/
        IF         COND(&RTCD1 *NE '       ' *AND &RTCD1 *NE +
                          '*NRF   ') THEN(DO)                        /*CFT008*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)                        /*CFT008*/
               CHGJOB     SWS(XXXXXX11)                              /*CFT008*/
               GOTO       CMDLBL(ENDPGM)                             /*CFT008*/
        ENDDO                                                        /*CFT008*/
/**     IF         COND(&RTCD *EQ '       ') THEN(DO)                  CFT008*/
        IF         COND(&RTCD *EQ '       ' *OR &RTCD1 *EQ +
                          '       ') THEN(DO)                        /*CFT008*/
/**********        CALL   PGM(FT0572) ***/                                                /*221652*/
/**********  CALL       PGM(FT0572) PARM(&PTYP &PBRCA &STRT +
                          &ENDT &RNTP &RSEQ &RLEV &RENT) */                        /*221652 226942*/
             CALL       PGM(FT0572) PARM(&PTYP &STRT &ENDT +
                          &PMENU &RNTP &RSEQ &RLEV &RENT)                                 /*226942*/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
ENDPGM:
        ENDPGM
