/********************************************************************/
/*  Start of /COPY GLC2601001                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *Create    Date 21Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
/*                                                                      LUC110*/
             CALL       PGM(AOSARDR0) PARM(&LUC110 '*VERIFY' +
                          'LUC110' &AOFMT)                            /*LUC110*/
             IF         COND(&LUC110 *EQ '       ') THEN(DO)          /*LUC110*/
             STRJRNPF   FILE(XXMANPX0) JRN(&JLIB/&JOURNAL) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*LUC110*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*LUC110*/

             CLRPFM     FILE(XXMANPX0)                                /*LUC110*/
             ENDDO       /*LUC110*/

/********************************************************************/
/*  End of /COPY GLC2601001                                         */
/********************************************************************/
