/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Cheques To Be Paid Maint. Level 2')          */
/********************************************************************/
/*                                                                  */
/*       Midas     - FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0085  - CL COMPONENT TO CONTROL FT0085                  */
/*                  CHEQUES TO BE PAID MAINTENANCE LEVEL 2          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  E42167(PSS206)   DATE   29JUL92            */
/*                       E29986           DATE   31JUL91            */
/*                       S01194           DATE   30JUL90            */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                             */
/*       E42167 - CL PROGRAM FOR RECORD LOCKING                     */
/*       E29986 - INPUT PARAMETERS IN INCORRECT ORDER               */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/**          PGM        PARM(&ACTION &PREF &COMMAND &LINK)           /*E29986*/
             PGM        PARM(&ACTION &PREF &LINK &COMMAND)           /*E29986*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1) /* Action +
                          code. */
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&COMMAND) TYPE(*CHAR) LEN(1) /* Command +
                          key. */
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1) /* Link parame +
                          ter. */
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&PREF2)  TYPE(*CHAR) LEN(15)              /*042167*/
 
/**DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                         /*S01194*/
   DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                         /*S01194*/
   CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/**OVRDBF CLINT SHARE(*NO)                                           /*S01194*/
 
   CALL       PGM(FT0085)    +
                        PARM(&ACTION &PREF &COMMAND &LINK)
   MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
              ROLLBACK
              SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                              Press Enter to Continue.') TOPGMQ(*EXT)
              GOTO END
   ENDDO
 
   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              ROLLBACK
/*************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)           /*S01194*/
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)           /*S01194*/
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
   ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*END********ENDPGM*************************************************/ /*042167*/
/* */                                                                 /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
 END:        IF         COND(&PREF2 *EQ *BLANKS) THEN(DO)             /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
             ENDDO                                                    /*042167*/
             ENDPGM                                                   /*042167*/
/* */
