      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Prompt control for UPDGENFLD')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT9006 - Prompt control for UPDGENFLD.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *  Last Amend No. CUP021  *CREATE    Date 12Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP021 - Creation of UPDGENFLD command.  This is part of a   *
      *           re-write of GENFLDNOS, to make it file driven.      *
      *                                                               *
      *****************************************************************
     FUTGENFL0  IF   E           K DISK
      /EJECT
      *
      * DS to convert the string length to binary/text format
     D                 DS
     D BinCtr                  1      2B 0
     D BinText                 1      2
      *
      * Constants for the keywords
     D HeaderKwd       C                   'HEADERFILE('
     D DetailKwd       C                   ') DETAIL('
      /SPACE 3
      *
     C     *ENTRY        PLIST
     C                   PARM                    Cmdname          20
     C                   PARM                    InAPIName         4
     C                   PARM                    Return          500
 
     C     GLIST         KLIST
     C                   KFLD                    KAPI              4
     C                   KFLD                    KSEQ              2 0
      *
      * Initialise return code, record counter and return code length (to 0)
     C                   Eval      Return = ' '
     C                   Z-ADD     1             Counter           2 0
     C                   Z-ADD     0             BinCtr
     C                   Eval      %Subst(Return:1:2) =  BinText
      *
      * Initialise Position field for substring operations (first two
      * bytes are (binary) string length)
     C                   Z-ADD     3             P                 5 0
      *
      *
      * Get the header and first 20 detail files for the requested API
     C                   Z-ADD     1             KSEQ
     C                   EVAL      KAPI = InAPIName
     C     GLIST         CHAIN     UTGENFL0                           99
      *
     C                   If        *IN99 = *OFF
     C                   Eval      %Subst(Return:P:11) =  HeaderKwd
     C                   Eval      P       = P + 11
     C                   Eval      %Subst(Return:P:21) =  %trim(HFFLIB) + '/' +
     C                             HFFILE
     C                   Eval      P = %scan(' ' : Return : P)
     C                   Eval      %Subst(Return:P:9) =  DetailKwd
     C                   Eval      P       = P + 9
     C                   Read      UTGENFL0                             9999
      *
     C                   DoW       *IN99 = *OFF and
     C                             HFAPIN = InAPIName and
     C                             Counter < 21
     C                   Eval      %Subst(Return:P:21) =  %trim(HFFLIB) + '/' +
     C                             HFFILE
     C                   Eval      Counter = Counter + 1
     C                   Eval      P = 1 + %scan(' ' : Return : P)
     C                   Read      UTGENFL0                             9999
     C                   EndDo
      *
      * Add the closing quote
     C                   Eval      P = P - 1
     C                   Eval      %Subst(Return:P:1) =  ')'
      *
      * Set the (Binary) string length and 'Detail file' count
     C                   Z-ADD     P             BinCtr
     C                   Eval      %Subst(Return:1:2) =  BinText
     C                   EndIf
      *
      * Exit
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
