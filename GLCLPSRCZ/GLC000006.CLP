/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL AWV Codes Initialisation')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLC000003 - Midas GL AWV Codes Initialization               */                   /*CER059*/
/*       GLC000006 - Midas GL AWV Codes Initialization               */                   /*CER059*/
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG22611           Date 02Feb09              */
/*                      CER044  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22611 - German Features initialization pgm error         */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*                                                                   */
/*********************************************************************/
 
/**********  PGM  */                                                                    /*BUG22611*/
             PGM        PARM(&RTCDE &PMODE)                                             /*BUG22611*/
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)                                  /*BUG22611*/
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)                                  /*BUG22611*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  SNDPGMMSG  MSG('GLC000003 - Midas GL AWV Codes +         */                  /*CER059*/
/**********               Initialization') TOMSGQ(MRUNQ)              */                  /*CER059*/
             SNDPGMMSG  MSG('GLC000006 - Midas GL AWV Codes +
                          Initialization') TOMSGQ(MRUNQ)                                  /*CER059*/
 
             IF         COND(&PMODE *NE '3') THEN(DO)                                   /*BUG22611*/
             CALL       PGM(SD200099) PARM('*GVC' '*GVC' 'Y')
             ENDDO                                                                      /*BUG22611*/
 /** If error occur */                                                                  /*BUG22611*/
                                                                                        /*BUG22611*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*BUG22611*/
               GOTO       CMDLBL(ABNOR)                                                 /*BUG22611*/
             ENDDO                                                                      /*BUG22611*/
 
             GOTO       CMDLBL(END)                                                     /*BUG22611*/
/**********  CHGVAR     VAR(&CPYFLD) VALUE('(c) +                     */                /*BUG22611*/
/**********               Finastra International Limited')            */                /*BUG22611*/
ABNOR:
 
 
/**********  SNDPGMMSG  MSG('Program GLC000003 ended abnormally') +   */                  /*CER059*/
/**********               TOMSGQ(MOPERQ MRUNQ)                        */                  /*CER059*/
             SNDPGMMSG  MSG('Program GLC000006 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER059*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:                                                                                    /*BUG22611*/
             ENDPGM
