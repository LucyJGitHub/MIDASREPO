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

             IF         COND(&LUC111 *EQ '       ') THEN(DO)
/**********  CLRPFM     FILE(SWPOSX0)                                */            /**/
                CLRPFM     FILE(XXSWPSX0)
/**********  CPYF       FROMFILE(SWPOOX0) TOFILE(SWPOSX0) +          */
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)                */            /**/
                CPYF       FROMFILE(XXSWPOX0) TOFILE(XXSWPSX0) MBROPT(*ADD) +
                             FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF2817)
             ENDDO

/********************************************************************/
/*  End of /COPY LUC111_002                                         */
/********************************************************************/
