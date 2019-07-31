/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Client Input Cycle Initiation DB save (SAVF)')        */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                   */
/*       SCC5100    -  INPUT CYCLE INITIATION DB SAVE (SAVF)         */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 249135             Date 13Jul07              */
/*                      CSC032  *CREATE    Date 03Apr07              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     249135 - Program Crashing during COB                          */
/*     CSC032 - Exit programs for Midas save and restore.            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*   Initial Processing                                             */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2007')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* ********** INSERT TATRA PROCESSING HERE ***************************** */
 
             GOTO       CMDLBL(END)                                                       /*249135*/
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC5100 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)                                                /*249135*/
/**********    SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +                   /*249135*/
/**********                 mmCnnnn ended abnormally - see job log') +                    /*249135*/
/**********                 TOMSGQ(MOPERQ)                                                /*249135*/
               MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
END:                                                                                      /*249135*/
             ENDPGM
