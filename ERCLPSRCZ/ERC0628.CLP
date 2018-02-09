/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Extract - Futures & Options')                */
/*********************************************************************/
/*                                                                   */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                   */
/*                                                                   */
/*       ERC0628 - ER Extract - Futures & Options                    */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG10459           Date 08Feb06              */
/*                      CER001             Date 25Apr05              */
/*                      ULX004             Date 25Apr97              */
/*                      067746  PT         Date 10Mar94              */
/*                      063766               DATE 14DEC93            */
/*                      ER0359               DATE 21SEP93            */
/*                      ER0201               DATE 11JAN93            */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       BUG10459 - ERC0600 on message wait                          */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*   ULX004 - Capital Adequacy                                       */
/*   067746 - WRONG CPF MESSAGE USED ---> A FEW MEMBERS MISSING      */
/*   063766 - No member may not exist if no EOC has been run         */
/*   ER0359 - Retrieve markets from market file and not from End of  */
/*            Centre data area                                       */
/*   ER0201 - New CLP program for FO extract                         */
/*-------------------------------------------------------------------*/
             PGM
 
             DCL        VAR(&PMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&A) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&USRDTA) TYPE(*CHAR) LEN(10)
/****        DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)          ER0359*/
             DCLF       FILE(MARKTD)
 
/* Loop to process all Market Centres contained in DTAARA/FFEOC      */
 
 /******     RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)             ER0359*/
/*           RCVF       RCDFMT(MARKTDF)                       /*ER0359 063766*/
/*           MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(OTC)) /*ER0359 063766*/
 
 LOOP:       CHGJOB     SWS(XXXXXX00)
   /*****    IF         COND(&A *GT 61) THEN(DO)            ER0359*/
   /*****        CHGVAR     VAR(&PMRKT) VALUE('  ')         ER0359*/
   /*****        ENDDO                                      ER0359*/
   /*****    ELSE DO                                        ER0359*/
   /*****        CHGVAR     VAR(&PMRKT) VALUE(%SST(&FFEOC &A 2)) ER0359*/
   /*****    ENDDO                                               ER0359*/
                                                                     /*063766*/
             RCVF       RCDFMT(MARKTDF) /*ER0359*/                   /*063766*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(OTC))        /*063766*/
                                                                     /*063766*/
/** Skip deleted market centre                                       */                 /*BUG10459*/
             IF         COND(&RECI *EQ '*') THEN(DO)                                    /*BUG10459*/
                 GOTO       CMDLBL(LOOP)                                                /*BUG10459*/
             ENDDO                                                                      /*BUG10459*/
                 CHGVAR     VAR(&PMRKT) VALUE(&MRKT)
 
/* Override files to Market members                                  */
 
/********    IF         COND(&PMRKT *NE '  ') THEN(DO)      ER0359*/
                                                                     /*063766*/
                 CHKOBJ     OBJ(TRANS7) OBJTYPE(*FILE) MBR(&MRKT )   /*063766*/
/*           MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(LOOP))   063766 67746*/
                 MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(LOOP))    /*67746*/
                                                                     /*063766*/
                 OVRDBF     FILE(PRICS) MBR(&PMRKT)
                 OVRDBF     FILE(TRANS7) MBR(&PMRKT)
                 OVRDBF     FILE(TRSET) MBR(&PMRKT)                  /*ULX004*/
                 CHGVAR     VAR(&USRDTA) VALUE('ER0628-' *cat &pmrkt)
                 OVRPRTF    FILE(ER0628AU) USRDTA(&USRDTA)
/********        ENDDO                                      ER0359*/
/********    ELSE DO                                        ER0359*/
/*               OVRDBF     FILE(PRICS) MBR(OTC)            ER0359*/
/*               OVRDBF     FILE(TRANS7) MBR(OTC)           ER0359*/
/*               CHGVAR     VAR(&USRDTA) VALUE('ER0628-OTC')ER0359*/
/*               OVRPRTF    FILE(ER0628AU) USRDTA(&USRDTA)  ER0359*/
/********    ENDDO                                          ER0359*/
 
/* Call ER Futures & Options Extract program                         */
 
             CALL       PGM(ER0628) PARM(&PMRKT)
 
/* DATABASE ERRORS, IF U7 + U8 ON                                    */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
 
/* If not last Market Centre (*Blanks = 'OTC'), then loop back       */
 
     /**     CHGVAR     VAR(&A) VALUE(&A + 2)                          ER0359*/
     /**     IF         COND(&PMRKT *NE '  ') THEN(GOTO CMDLBL(LOOP))  ER0359*/
                                                                     /*ER0359*/
/*           RCVF       RCDFMT(MARKTDF)                       /*ER0359 063766*/
/*           MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(OTC)) /*ER0359 063766*/
             GOTO       CMDLBL(LOOP)                                 /*ER0359*/
 
 OTC:        OVRDBF     FILE(PRICS) MBR(OTC)                         /*ER0359*/
                 OVRDBF     FILE(TRANS7) MBR(OTC)                    /*ER0359*/
                 OVRDBF     FILE(TRSET) MBR(OTC)                     /*ULX004*/
                 CHGVAR     VAR(&USRDTA) VALUE('ER0628-OTC')         /*ER0359*/
                 OVRPRTF    FILE(ER0628AU) USRDTA(&USRDTA)           /*ER0359*/
                                                                     /*ER0359*/
/* Call ER Futures & Options Extract program                         /*ER0359*/
                                                                     /*ER0359*/
             CALL       PGM(ER0628) PARM(&PMRKT)                     /*ER0359*/
                                                                     /*ER0359*/
             DLTOVR     FILE(*ALL)
 
 
ENDPGM:      ENDPGM
