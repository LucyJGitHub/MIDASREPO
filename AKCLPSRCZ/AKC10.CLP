/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AK Account Keys Generation Set-up')             */
/********************************************************************/
/*                                                                  */
/*   Midas - Account Key Generator                                  */
/*                                                                  */
/*   AKC10    - Account Keys Generation Set-up                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      103747             Date 10Apr97              */
/*                  S01408             Date  04May95                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   CCB020 - COB Restructure - Secondary COB Infrastracture        */
/*   103747 - Check whether PF/SEACKD and PF/ACKEYAL are allocated  */
/*            to another job.                                       */
/*   S01408 - Addition of core hook AKC10MPS                        */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL       VAR(&MPHAS)  TYPE(*CHAR) LEN(1)
/************DCL       VAR(&ALC)    TYPE(*LGL)  LEN(1) VALUE('0')  */ /*103747*/
             DCL       VAR(&LIBR)   TYPE(*CHAR) LEN(2)
             DCL       VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL       VAR(&DMLIB)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*********************************************************************/
/*                                                                   */
/* Initialise program.                                               */
/*                                                                   */
/*********************************************************************/
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(END))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Set up DM library with correct prefix.                            */
/*                                                                   */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&LIBR *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC10MPS                                            */
                                                                      /*S01408*/
/*                                                                   */
/* Send error message and exit program if MPHAS not equal to 'A'.    */
/*                                                                   */
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND +
                        (&MPHAS *NE 'G')) THEN(DO)                                        /*CCB020*/
             SNDPGMMSG  MSG('Account Key Generation cannot be run at +
                          this time. Phase of Day must be A.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             ELSE       CMD(DO)
/*                                                                   */
/* Allocate ACKEYAL and ACKEYAK to ensure no other user can access   */
/* Account Key files while generation is in progress.                */
/*                                                                   */
             ALCOBJ     OBJ((&DMLIB/ACKEYAL *FILE *EXCL) +
                          (&DMLIB/ACKEYAK *FILE *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1085 CPF1002) EXEC(DO)
/************SNDPGMMSG  MSG('Account Keys file(s) in use by another +
/************             job. Try generation later.') TOPGMQ(*EXT)*/ /*103747*/
/************GOTO       CMDLBL(END)                                */ /*103747*/
             CHGJOB     SWS(1XXXXXXX)                                 /*103747*/
             ENDDO
/************CHGVAR     VAR(&ALC) VALUE('1')                       */ /*103747*/
             ALCOBJ     OBJ((&DMLIB/SEACKD *FILE *EXCL) +
                          (&DMLIB/XSEACKD *FILE *EXCL)) WAIT(5)       /*103747*/
             MONMSG     MSGID(CPF1085 CPF1002) EXEC(DO)               /*103747*/
             CHGJOB     SWS(X1XXXXXX)                                 /*103747*/
             ENDDO                                                    /*103747*/
             IF         COND(%SWITCH(11XXXXXX)) THEN(DO)              /*103747*/
             SNDPGMMSG  MSG('Account Keys file(s) in use by another +
                          job. Try generation later.') TOPGMQ(*EXT)   /*103747*/
             GOTO       CMDLBL(END)                                   /*103747*/
             ENDDO                                                    /*103747*/
/*                                                                   */
/* Call module selection program.                                    */
/*                                                                   */
             CALL       PGM(AK0010)
/*                                                                   */
             ENDDO
/*                                                                   */
 
/*********************************************************************/
/*                                                                   */
/* Close of program processing.                                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Deallocate ACKEYAL and ACKEYAK.                                   */
/*                                                                   */
/**END:******CHGJOB     SWS(XXX0XXXX)                              */ /*103747*/
   END:                                                               /*103747*/
 
/************IF         COND(&ALC) THEN(DO)                        */ /*103747*/
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)              /*103747*/
             DLCOBJ     OBJ((&DMLIB/ACKEYAL *FILE *EXCL) +
                          (&DMLIB/ACKEYAK *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
                        ENDDO
             IF         COND(%SWITCH(X0XXXXXX)) THEN(DO)              /*103747*/
             DLCOBJ     OBJ((&DMLIB/SEACKD *FILE *EXCL) +
                          (&DMLIB/XSEACKD *FILE *EXCL))               /*103747*/
             MONMSG     MSGID(CPF0000)                                /*103747*/
             ENDDO                                                    /*103747*/
             CHGJOB     SWS(00X0XXXX)                                 /*103747*/
 
             ENDPGM
