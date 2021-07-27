/********************************************************************/
/*  Start of /COPY LUC111_002                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC111             Date 24Jan19                  */
/*  Prev Amend No. NUC003 (S25019)    Date 16Jun05   *CREATE        */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC111 - Upgrade R4/NUC003 as FB 2.1 LUC111                     */
/*  NUC003 - OUTPUT EXTENDED NARRATIVES FOR GL, DL AND RE           */
/*           MODULES TO SWIFT MT940 STATEMENTS FIELD 86.            */
/*                                                                  */
/********************************************************************/
 
             IF         COND(&LUC111 *EQ '       ') THEN(DO)                              /*LUC111*/
/**********  CLRPFM     FILE(SWPOSX0)                                */            /*NUC003 LUC111*/
             CLRPFM     FILE(XXSWPSX0)                                                    /*LUC111*/
/**********  CPYF       FROMFILE(SWPOOX0) TOFILE(SWPOSX0) +          */                   /*LUC111*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)                */            /*NUC003 LUC111*/
             CPYF       FROMFILE(XXSWPOX0) TOFILE(XXSWPSX0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                                     /*LUC111*/
             MONMSG     MSGID(CPF2817)                                                    /*NUC003*/
             ENDDO                                                                        /*LUC111*/
 
/********************************************************************/
/*  End of /COPY LUC111_002                                         */
/********************************************************************/
