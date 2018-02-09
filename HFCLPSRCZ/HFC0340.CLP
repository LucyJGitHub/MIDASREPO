/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Copy save file data on tape')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - History and Audit Facility Module                   */
/*                                                                   */
/*       HFC0340  - SAVE DATA TO TAPE                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      088067             Date 16Jun95              */
/*                      S01408             DATE 04May95              */
/*                      049980             DATE 03FEB93              */
/*                      S01379             DATE 17SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       192731 - Change SAVOBJ/SAVSAVFDTA cmds to have USEOPTBLK*NO */
/*                instead of *YES                                    */
/*       088067 - Delete XX file after backup                        */
/*       S01408 - Addition of core hook HFC0340MP1                   */
/*       049980 - Access AOHAFDR0 to determine the value of field    */
/*                ETSAVE (Save HAF data to media.)                   */
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&VOL) TYPE(*CHAR) LEN(10) VALUE(HFSAVE)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNIT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)  +
                           VALUE('*DBERR ')                           /*049980*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                           VALUE('*FIRST ')                           /*049980*/
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)                 /*049980*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*049980*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)             /*049980*/
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */                                                                 /*049980*/
/* Get ICD information on 'Save HAF data to media' */                 /*049980*/
/* */                                                                 /*049980*/
             CALL       AOHAFDR0 PARM(&RTCD &OPTN &DSFDY)             /*049980*/
             CHGVAR     VAR(&SAVE) VALUE(%SST(&DSFDY 20 1))           /*049980*/
             IF         COND(&SAVE *NE 'Y') THEN(DO)                  /*049980*/
                RTVMSG     MSGID(HFM0013) MSGF(MIDASMSG) +
                           MSG(&MESSAGE)                              /*049980*/
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                           VALUE(%SST(&MESSAGE 1 44))                 /*049980*/
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                           VALUE(%SST(&MESSAGE 46 32))                /*049980*/
                CALL       PGM(HFC0010) PARM('HFC0340' 'ENTER' +
                           &REPLY)                                    /*049980*/
                GOTO       CMDLBL(END)                                /*049980*/
             ENDDO                                                    /*049980*/
             ELSE       CMD(CHGVAR VAR(&UNIT) +
                        VALUE(%SST(&DSFDY 21 10)))                    /*049980*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
             CHGVAR     VAR(&DILIB) VALUE(&LID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,HFC0340MP1                                          */
                                                                      /*S01408*/
 
 
             RTVDTAARA  DTAARA(HFSAVE (1 6)) RTNVAR(&DAT)
 
 
/* */
/* Clear the save file if it exists */
/* */
             CLRSAVF    FILE(&DILIB/HFSAVE)
             MONMSG     MSGID(CPF9812) EXEC(CRTSAVF +
                          FILE(&DILIB/HFSAVE) TEXT('Midas +
                          HF save file'))
 
/* */
/* Check for existence of XX in the xxHFLIB */
/* */
             CHKOBJ     OBJ(&HFLIB/XX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('There is no data available to be saved. +
                          SAVE CANCELLED') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Save the data to save file */
/* */
/**********  SAVOBJ     OBJ(XX) LIB(&HFLIB) DEV(*SAVF) +
/**********               SAVF(&DILIB/HFSAVE)                                         /*192731*/
/**********  SAVOBJ     OBJ(XX) LIB(&HFLIB) DEV(*SAVF) +     */                /*192731*/ /*207764*/
/**********               SAVF(&DILIB/HFSAVE) USEOPTBLK(*NO) */                /*192731*/ /*207764*/
             SAVOBJ     OBJ(XX) LIB(&HFLIB) DEV(*SAVF) +
                          SAVF(&DILIB/HFSAVE) USEOPTBLK(*NO) +
                          OUTPUT(*PRINT)                                                  /*207764*/
 
/* */
/* Decide where to save the data to */
/* */
/*RETRY:**** RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&UNIT) */       /*049980*/
 RETRY:                                                               /*049980*/
/*/COPY WNCPYSRC,HFC0340001                                          */
 
/* */
/* Check the correct volume is mounted */
/* */
             CHKTAP     DEV(&UNIT) VOL(&VOL)
 
/* */
/* Wrong volume so send message */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Send messages to inform user of problem, to rectify it or cancel */
/* */
             SNDPGMMSG  MSG(' ') TOPGMQ(*EXT) MSGTYPE(*DIAG) /* +
                          Blank Line */
             SNDPGMMSG  MSG('HAF has detected the incorrect +
                          volume on tape drive' *BCAT &UNIT) +
                          TOPGMQ(*EXT) MSGTYPE(*DIAG) /* Info first */
             SNDPGMMSG  MSG('Please mount volume' *BCAT &VOL *BCAT +
                          'on tape drive' *BCAT &UNIT) TOPGMQ(*EXT) +
                          MSGTYPE(*DIAG) /* More info */
             SNDUSRMSG  MSG('C to cancel save, any other key to +
                          retry.') TOMSGQ(*EXT) MSGRPY(&REPLY) /* +
                          Action to take */
 
/* */
/* Check the reply. If C then cancel otherwise go back to look at */
/* JNSTAT in case the save destination has been changed. */
/* */
             IF         COND((&REPLY *EQ 'C') *OR (&REPLY *EQ 'c')) +
                          THEN(DO)
             SNDPGMMSG  MSG('Save cancelled at the request of the +
                          user') TOPGMQ(*EXT) /* Abandoned */
             GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(RETRY)
             ENDDO
 
/* */
/* Now save the data to tape */
/* */
/*/COPY WNCPYSRC,HFC0340003                                          */
/**********  SAVSAVFDTA SAVF(&DILIB/HFSAVE) DEV(&UNIT) VOL(&VOL) +
/**********               ENDOPT(*UNLOAD)                                             /*192731*/
             SAVSAVFDTA SAVF(&DILIB/HFSAVE) DEV(&UNIT) VOL(&VOL) +
                          ENDOPT(*UNLOAD) USEOPTBLK(*NO)                              /*192731*/
 
/*/COPY WNCPYSRC,HFC0340004                                          */
/* */
/* Monitor in case save fails */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error attempting to save HAF data to +
                          tape on device' *BCAT &UNIT *BCAT +
                          'Program terminated.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,HFC0340002                                          */
/* */
/* Rename the saved data file. Delete the renamed file first */
/* */
             DLTF       FILE(&HFLIB/#XX)
             MONMSG     MSGID(CPF0000)
             RNMOBJ     OBJ(&HFLIB/XX) OBJTYPE(*FILE) NEWOBJ(#XX)
/**/                                                                  /*088067*/
             DLTF       FILE(&HFLIB/XX)                               /*088067*/
             MONMSG     MSGID(CPF0000)                                /*088067*/
/**/                                                                  /*088067*/
 
/* */
/* Call HF0340 to update sequence number */
/* */
             CALL       PGM(HF0340) PARM(&DAT)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Error updating history file in journal +
                          save') TOPGMQ(*EXT)
             ENDDO
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0340 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CALL       PGM(AOHAFDR0) PARM(&RTCD '*FREE' &DSFDY)      /*049980*/
             ENDPGM
