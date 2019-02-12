/********************************************************************/
/*  Start of /COPY GLC1300001                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC111             Date 24Jan19                  */
/*  Prev Amend No. NUC003 (S25019)    Date 16Jun05                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC111 - Upgrade of R4/NUC003 as FB 2.1 LUC111                  */
/*  NUC003 - OUTPUT EXTENDED NARRATIVES FOR GL, DL AND RE           */
/*           MODULES TO SWIFT MT940 STATEMENTS FIELD 86.            */
/*                                                                  */
/********************************************************************/
 
             CALL       PGM(AOSARDR0) PARM(&LUC111 '*VERIFY' +
                          'LUC111' &AOFMT)                                                /*LUC111*/
             IF         COND(&LUC111 *EQ '       ') THEN(DO)                              /*LUC111*/
/*********   CLRPFM     FILE(SWPOOX0)                                */            /*NUC003 LUC111*/
             CLRPFM     FILE(XXSWPOX0)                                                    /*NUC003*/
             ENDDO                                                                        /*LUC111*/
 
/********************************************************************/
/*  End of /COPY GLC1300001                                         */
/********************************************************************/
