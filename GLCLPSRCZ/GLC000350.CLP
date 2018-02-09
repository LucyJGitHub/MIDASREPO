/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL AWV Extract Consolidation, Report')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC000350 - Midas GL AWV Extract Consolidation, Report      */
/*                   and Housekeep                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG26298           Date 06Oct09              */
/*                      BUG23276           Date 10Mar09              */
/*                      CER044  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26298 - Enable export to Meridian                        */
/*       BUG23276 - Items with Customers set up as Banks not shown   */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/*  Clear the Extract file and its Extension Table                   */
 
             CLRPFM     FILE(GLAWVEPD)
             CLRPFM     FILE(GLAWVXPD)
             CLRPFM     FILE(GLAWAEPD)                                                  /*BUG26298*/
 
/*  Copying the data from Dealing, Lending & Retail file to          */
/*  the AWV extract file.                                            */
 
             CPYF       FROMFILE(GLAWVDPD) TOFILE(GLAWVEPD) +
                          MBROPT(*ADD)
 
             CPYF       FROMFILE(GLAWVLPD) TOFILE(GLAWVEPD) +
                          MBROPT(*ADD)
 
             CPYF       FROMFILE(GLAWVRPD) TOFILE(GLAWVEPD) +
                          MBROPT(*ADD)
 
 
/*  Copying the data from Dealing, Lending & Retail Extension        */
/*  file to the AWV extract extension file.                          */
 
             CPYF       FROMFILE(GLAWXDPD) TOFILE(GLAWVXPD) +
                          MBROPT(*ADD)
 
             CPYF       FROMFILE(GLAWXLPD) TOFILE(GLAWVXPD) +
                          MBROPT(*ADD)
 
             CPYF       FROMFILE(GLAWXRPD) TOFILE(GLAWVXPD) +
                          MBROPT(*ADD)
 
 
             CALL       PGM(GL000350)
                                                                                        /*BUG26298*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*BUG26298*/
                GOTO       CMDLBL(ABNOR)                                                /*BUG26298*/
             ENDDO                                                                      /*BUG26298*/
                                                                                        /*BUG26298*/
             CALL       PGM(MXC0010) PARM('*NONE   ' 'GLAWVEXX  ')                      /*BUG26298*/
             CALL       PGM(MXC0020) PARM('*NONE   ' ' ' 'GLAWVEXX  ')                  /*BUG26298*/
                                                                                        /*BUG26298*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*BUG26298*/
                GOTO       CMDLBL(ABNOR)                                                /*BUG26298*/
             ENDDO                                                                      /*BUG26298*/
                                                                                        /*BUG23276*/
/*  Clear data from Dealing, Lending & Retail Extract files and      */                 /*BUG23276*/
/*  Extension files                                                  */                 /*BUG23276*/
                                                                                        /*BUG23276*/
             CLRPFM     FILE(GLAWVDPD)                                                  /*BUG23276*/
             CLRPFM     FILE(GLAWXDPD)                                                  /*BUG23276*/
                                                                                        /*BUG23276*/
             CLRPFM     FILE(GLAWVLPD)                                                  /*BUG23276*/
             CLRPFM     FILE(GLAWXLPD)                                                  /*BUG23276*/
                                                                                        /*BUG23276*/
             CLRPFM     FILE(GLAWVRPD)                                                  /*BUG23276*/
             CLRPFM     FILE(GLAWXRPD)                                                  /*BUG23276*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             GOTO       CMDLBL(END)
ABNOR:
 
 
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000)      */
 
             SNDPGMMSG  MSG('Program GLC000350 ended abnormally - +
                          See job log') TOMSGQ(MOPERQ MRUNQ)
             DMPCLPGM
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
END:
             ENDPGM
