     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  CRTSRCPF FILE(QTEMP/CRTOBJSQF) RCDLEN(112) MBR(CRTOBJSQL)    *
/*XBIB*  RNMOBJ OBJ(QTEMP/CRTOBJSQF) OBJTYPE(*FILE)                   *
/*XBIB*  NEWOBJ(CRTOBJSQL)                                            *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Execute SQL script for REC000082')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000082 - Execute SQL Script for REC000082                  *
      *             Initialisation Program                            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Function: Set F1IABC field on GLACNTQD to 'Y' only if        *
      *            retail and not nostro account                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG18886            Date 27May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE010 *C *CREATE  Date 06Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG18886 - Amend non-standard codes.                          *
      *  CRE010 - Retail Account Balance Check                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
     FCRTOBJSQL IF A E             DISK    USROPN
 
      * General variables
 
     D CommandString   S             80
     D Wrun            S              1
 
      * QCMDEXC parameters
 
     D CmdStrRunSQL    S             66
     D CmdLenRunSQL    S             15  5 INZ(66)
     D CmdStrClrSQL    S             37
     D CmdLenClrSQL    S             15  5 INZ(37)
 
      * SQL statment building blocks for insert processing
 
     D CommandStrng01  C                   'UPDATE GLACNTQD SET F1IABC = '
     D CommandStrng02  C                   ' '
     D CommandStrng03  C                   'UPDATE GLACNTQD SET F1IABC = '
     **********CommandStrng04  C                   'WHERE DIGITS(F1CNUM)**F1CCY**'           BG18886
     **********CommandStrng05  C                   'DIGITS(F1ACOD)**DIGITS(F1ACSQ) IN '      BG18886
     **********CommandStrng06  C                   '(SELECT DIGITS(CNUM)**CCY**'             BG18886
     **********CommandStrng07  C                   'DIGITS(ACOD)**DIGITS(ACSQ)'              BG18886
     D CommandStrng04  C                   'WHERE DIGITS(F1CNUM) CONCAT F1CCY +
     D                                      CONCAT'                                          BG18886
     D CommandStrng05  C                   'DIGITS(F1ACOD) CONCAT             +
     D                                      DIGITS(F1ACSQ) IN '                              BG18886
     D CommandStrng06  C                   '(SELECT DIGITS(CNUM) CONCAT CCY +
     D                                      CONCAT'                                          BG18886
     D CommandStrng07  C                   'DIGITS(ACOD) CONCAT DIGITS(ACSQ)'                BG18886
     D CommandStrng08  C                   'FROM ACCNTAB WHERE ATYP= '
     **********CommandStrng09  C                   'AND DIGITS(F1CNUM)**F1CCY**'             BG18886
     **********CommandStrng10  C                   'DIGITS(F1ACOD)**DIGITS(F1ACSQ) '         BG18886
     **********CommandStrng11  C                   'NOT IN (SELECT A7CUST**'
     **********CommandStrng12  C                   'A7CYCD**A7ACCD**DIGITS(A7ACSN)'          BG18886
     D CommandStrng09  C                   'AND DIGITS(F1CNUM) CONCAT F1CCY +
     D                                      CONCAT'                                          BG18886
     D CommandStrng10  C                   'DIGITS(F1ACOD) CONCAT +
     D                                      DIGITS(F1ACSQ) '                                 BG18886
     D CommandStrng11  C                   'NOT IN (SELECT A7CUST CONCAT'                    BG18886
     D CommandStrng12  C                   'A7CYCD CONCAT A7ACCD CONCAT +
     D                                      DIGITS(A7ACSN)'                                  BG18886
     D CommandStrng13  C                   'FROM SDNOSTPD);'
 
      * RUNSQL statement building blocks
 
     D RUNSQL_Cmd      C                   'RUNSQLSTM SRCFILE(QTEMP/CRTOBJSQL) +
     D                                     SRCMBR(CRTOBJSQL) COMMIT(*NONE)'
 
      * CLRPFM statement building blocks
 
     D CLRSQL_Cmd      C                   'CLRPFM FILE(CRTOBJSQL) +
     D                                     MBR(CRTOBJSQL)'
 
     C                   EVAL      CmdStrRunSQL = RUNSQL_Cmd
     C                   EVAL      CmdStrClrSQL = CLRSQL_Cmd
 
      * Create the work SRCPF in QTEMP
 
     C                   CALL      'UPC000798'
 
      * Clear the SQL member
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrClrSQL
     C                   PARM                    CmdLenClrSQL
 
      * Build the SQL statement
 
     C                   OPEN      CRTOBJSQL
 
      * Command line 1
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng01 + '''' + 'N' + ''';'
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 2
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng02
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 3
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng03 + '''' + 'Y' + ''''
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 4
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng04
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 5
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng05
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 6
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng06
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 7
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng07
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 8
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng08 + '''' + 'R' + ''''
     C                                      + ')'
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 9
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng09
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 10
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng10
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 11
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng11
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 12
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng12
 
     C                   WRITE     CRTOBJSQF
 
      * Command line 13
 
     C                   EVAL      SRCDTA = *BLANKS
     C                   EVAL      SRCDTA = CommandStrng13
 
     C                   WRITE     CRTOBJSQF
 
      * Execute the SQL statement
 
     C                   CLOSE     CRTOBJSQL
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStrRunSQL
     C                   PARM                    CmdLenRunSQL
 
     C                   EVAL      *INLR = *ON
     C
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
