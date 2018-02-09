/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT RFT / CCT list / audit report - Orig.brch')  */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0233    Authorised RFT / CCT Report by Originating brch  */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG25160           Date 23Jul09              */
/* Midas Release 4.04 -----------------------------------------------*/
/*                      226942             Date 21May04              */
/*                      221652  *CREATE    Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG25160 - Apply core fix 226942 and 221652.                */
/*       226942 - Make RFT/CCT Authorised/Unauthorised reports       */
/*                available in the system.                           */
/*       221652 - Make report request available in the system.       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
 
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)
        DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
        DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                     VALUE('CFT006')
        DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
        DCL        VAR(&SARD1) TYPE(*CHAR) LEN(6) +
                     VALUE('CFT008')
        DCL        VAR(&RTCD1) TYPE(*CHAR) LEN(7)
        DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
        DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2)
/*******DCL        VAR(&PBRCA) TYPE(*CHAR) LEN(3) */                                      /*226942*/
        DCL        VAR(&STRT) TYPE(*DEC) LEN(5 0)
        DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0)
        DCL        VAR(&PMENU) TYPE(*CHAR) LEN(3)                                         /*226942*/
        DCL        VAR(&RNTP) TYPE(*CHAR) LEN(1)
        DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
/**/
        SNDPGMMSG MSG('FT0573 - RFT / CCT LIST report') +
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
        CHGVAR     VAR(&RNTP) VALUE(%SST(&PARM 4 1))
        CHGVAR     VAR(&PTYP) VALUE(%SST(&PARM 5 2))
/*******CHGVAR     VAR(&PBRCA) VALUE(%SST(&PARM 7 3)) */                                  /*226942*/
        CHGVAR     VAR(&STRT) VALUE(%SST(&PARM 10 5))
        CHGVAR     VAR(&ENDT) VALUE(%SST(&PARM 15 5))
        CHGVAR     VAR(&PMENU) VALUE(%SST(&PARM 20 3))                                    /*226942*/
/**/
/** RFT / CCT LIST REPORT **/
/**/
        CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
        IF     COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
        ENDDO
 
        CALL       PGM(AOSARDR0) PARM(&RTCD1 &OPTN &SARD1)
        IF         COND(&RTCD1 *NE '       ' *AND &RTCD1 *NE +
                          '*NRF   ') THEN(DO)
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
        ENDDO
        IF         COND(&RTCD *EQ '       ' *OR &RTCD1 *EQ +
                          '       ') THEN(DO)
/**********  CALL       PGM(FT0573) PARM(&PTYP &PBRCA &STRT +
                          &ENDT &RNTP &RSEQ &RLEV &RENT) */                               /*226942*/
             CALL       PGM(FT0573) PARM(&PTYP &STRT &ENDT +
                          &PMENU &RNTP &RSEQ &RLEV &RENT)                                 /*226942*/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
ENDPGM:
        ENDPGM
