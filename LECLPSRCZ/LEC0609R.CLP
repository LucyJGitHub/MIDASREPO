/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ER LE Events File Creation')                    */
/*********************************************************************/
/*                                                                   */
/*     MIDAS/ABS  CUSTOMER LENDING MODULE                            */
/*                                                                   */
/*     LEC0609R -  EVENTS FILE CREATION FOR ER                       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. CLE071             Date 18Jul18              */
/*                      MD046248           Date 27Oct17              */
/*                      MD021605           Date 22Aug13              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      UPG402             Date 04Oct04              */
/*                      124371             Date 23Oct97              */
/*                      ERL454 PT          Date 01Feb95              */
/*                      ERL416 PT          Date 25Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       CLE071 - Value Dating of Rate Changes to Fees (Recompile)   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021605 - Add a parameter for LE0480.                      */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       UPG402 - Recompile due to R4.02 upgrade                     */
/*       124371 - REPAYMENTS ARE NOT GENERATED IN THE EOM.           */
/*       ERL454 - CPYF COMMAND NOT MONITORED FOR EMPTY FILE          */
/*       GENERATE ALL EVENTS FOR ER (RERUN LE0480 IF NECESSARY)      */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                   */                   /*MD049139*/
             PGM        PARM(&RUNCOND)                                                  /*MD049139*/
                                                                                        /*MD049139*/
             DCL        VAR(&RUNCOND) TYPE(*CHAR) LEN(6)                                /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/

/************DCLF       FILE(TABTB50)                                   ER_R10*/
             DCLF       FILE(SDCLNDPD)                                /*ER_R10*/
/************RCVF       RCDFMT(TABTB50F)                                ER_R10*/
             RCVF       RCDFMT(SDCLNDD0)                              /*ER_R10*/

             SNDPGMMSG  MSG('CUSTOMER LENDING EVENTS FILE CREATION +
                          FOR ER') TOMSGQ(MRUNQ)

/** Determine if switchable feature CLE025 is switched ON then     */                   /*MD049139*/
/** check if program should run based on feature and parameter     */                   /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              (&RUNCOND *EQ 'CLE025')) *OR +
                             ((&CLE025 *NE 'Y') *AND +
                              (&RUNCOND *NE 'CLE025'))) THEN(GOTO +
                        CMDLBL(ENDPGM))                                                 /*MD049139*/
                                                                                        /*MD049139*/
             CHGJOB     SWS(01XXXXXX)

             CLRPFM     FILE(ERLVENHH)
             CLRPFM     FILE(ERLVENPD)
             CLRPFM     FILE(ERLVENZZ)

/************IF         COND(&EEOB *NE 'Y') THEN(DO)                    ER_R10*/
/**********  IF         COND(&BPGEEB *NE 'Y') THEN(DO)  *ER_R10*        124371*/
             OVRDBF     FILE(TABLE) TOFILE(TABLEEI)
             OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)
             OVRDBF     FILE(LVNTXHH) TOFILE(ERLVENHH)
             OVRDBF     FILE(LVNTXEL) TOFILE(ERLVENPD) SEQONLY(*YES +
                          100)
             OVRDBF     FILE(LVNTXZZ) TOFILE(ERLVENZZ)

/**********  CALL       PGM(LE0480)                                */                   /*MD021605*/
             CALL       PGM(LE0480) PARM(' ')                                           /*MD021605*/

             DLTOVR     FILE(*ALL)
 /*          ENDDO                                                      124371*/

/************IF         COND(&EEOB *EQ 'Y') THEN(DO)                    ER_R10*/
/*           IF         COND(&BPGEEB *EQ 'Y') THEN(DO)     *ER_R10*     124371*/
/*           CPYF       FROMFILE(LVENTEL) TOFILE(ERLVENPD) +            124371*/
/*                        MBROPT(*REPLACE) FMTOPT(*MAP *DROP)           124371*/
/* ERL454 START                                                         124371*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +    124371*/
/*                        FILE(ERLVENPD))                               124371*/
/* ERL454 END                                                           124371*/
/*           ENDDO                                                      124371*/

             CHGJOB     SWS(00XXXXXX)

ENDPGM:      ENDPGM
