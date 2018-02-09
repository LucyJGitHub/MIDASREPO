/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Call SD Enquiries')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standing Data Module                              */
/*                                                                   */
/*       SDC0900  - CL COMPONENT TO CONTROL SD ENQUIRIES             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 251436             Date 20Nov07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      087757             Date 24Oct95              */
/*                      S01125            Date  03/11/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       251436 - Add parameter 'N' when calling SD0930.             */
/*                'N' for Non Collateral Account Keys enquiry.       */
/*                'Y' for Collateral Account Keys enquiry in         */
/*                SDC000930.                                         */
/*       087757 - Check if A/C key file is being used by another     */
/*                workstation for update.                            */
/*       S01125 - REMOVE THE LDA                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(45)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*087757*/
             CHGJOB     SWS(XXXXXX00)
                                                                      /*087757*/
/** If A/C Keys Maintenance, check if file is being used by another    *087757*/
/** workstation for update                                             *087757*/
                                                                      /*087757*/
             IF         COND(&PGM *EQ 'SD0930    ') THEN(DO)          /*087757*/
                                                                      /*087757*/
               ALCOBJ     OBJ((ACKEYAL *FILE *SHRRD)) WAIT(0)         /*087757*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))       /*087757*/
               DLCOBJ     OBJ((ACKEYAL *FILE *SHRRD))                 /*087757*/
               ALCOBJ     OBJ((ACKEYAK *FILE *SHRRD)) WAIT(0)         /*087757*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))       /*087757*/
               DLCOBJ     OBJ((ACKEYAK *FILE *SHRRD))                 /*087757*/
               GOTO       CMDLBL(CONTINUE)                            /*087757*/
                                                                      /*087757*/
             ENDDO                                                    /*087757*/
 MSG:                                                                 /*087757*/
               RTVMSG     MSGID(SCM0086) MSGF(MIDASMSG) MSG(&MESSAGE) /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)   /*087757*/
               RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE) /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)   /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')          /*087757*/
               CALL       PGM(SCC0010) PARM('SDC0900' 'ENTER' ' ')    /*087757*/
               GOTO       CMDLBL(ENDCLPGM)                            /*087757*/
 CONTINUE:                                                            /*087757*/
/********    CALL       PGM(&PGM)                                       251436*/
             IF         COND(&PGM *EQ 'SD0930    ') THEN(CALL +
                          PGM(&PGM) PARM('N'))
             ELSE       CMD(CALL PGM(&PGM))                           /*251436*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/                                                                  /*S01125*/
/***************RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&DATA)******************/
             CHGVAR     VAR(%SUBSTRING(&DATA 1 10)) +
                          VALUE('TABLEICDR1')
             CHGVAR     VAR(%SUBSTRING(&DATA 35 8)) +
                          VALUE(&PGM)
             CHGVAR     VAR(%SUBSTRING(&DATA 43 2)) +
                          VALUE('01')
/**/                                                                  /*S01125*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
ENDCLPGM:                                                             /*087757*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
