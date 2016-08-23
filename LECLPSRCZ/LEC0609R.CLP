/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ER LE Events File Creation')                    */
/*********************************************************************/
/*                                                                  */
/*     MIDAS/ABS  CUSTOMER LENDING MODULE                           */
/*                                                                  */
/*     LEC0609R -  EVENTS FILE CREATION FOR ER                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/*       Last Amend No. MD021605           Date 22Aug13              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      UPG402             Date 04Oct04              */
/*                      124371             Date 23Oct97              */
/*                    ERL454 PT          DATE 01FEB95               */
/*                    ERL416 PT          DATE 25JUL94               */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     MD021605 - Add a parameter for LE0480.                       */
/*     CLE134 - Past Due Call Loan Processing (Recompile)           */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     UPG402 - Recompile due to R4.02 upgrade                      */
/*     124371 - REPAYMENTS ARE NOT GENERATED IN THE EOM.            */
/*     ERL454 - CPYF COMMAND NOT MONITORED FOR EMPTY FILE           */
/*     GENERATE ALL EVENTS FOR ER (RERUN LE0480 IF NECESSARY)       */
/*                                                                  */
/********************************************************************/
             PGM
 
/************DCLF       FILE(TABTB50)                                   ER_R10*/
             DCLF       FILE(SDCLNDPD)                                /*ER_R10*/
/************RCVF       RCDFMT(TABTB50F)                                ER_R10*/
             RCVF       RCDFMT(SDCLNDD0)                              /*ER_R10*/
 
             SNDPGMMSG  MSG('CUSTOMER LENDING EVENTS FILE CREATION +
                          FOR ER') TOMSGQ(MRUNQ)
 
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
