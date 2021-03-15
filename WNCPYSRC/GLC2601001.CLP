/********************************************************************/
/*  Start of /COPY GLC2601001                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *CREATE    Date 21Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
/*                                                                            */
             CALL       PGM(AOSARDR0) PARM(&LUC110 '*VERIFY' +
                          'LUC110' &AOFMT)                                      
             IF         COND(&LUC110 *EQ '       ') THEN(DO)                    
             STRJRNPF   FILE(XXMANPX0) JRN(&JLIB/&JOURNAL) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                        
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                          

             CLRPFM     FILE(XXMANPX0)                                          
             ENDDO                 

/********************************************************************/
/*  End of /COPY GLC2601001                                         */
/********************************************************************/
