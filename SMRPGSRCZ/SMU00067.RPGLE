     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Old points field on FWDRTFE redundant')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00067 -  Forward rates FWDRTFE file changed               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 089129             Date 3MAy02                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S08912901.                         *
      *  089129  - Use new field for points in FWDRTFE, old points    *
      *            field is redundant.                                *
      *****************************************************************
      *
     FFWDRTFE   IP   F  611        DISK                                                       089129
     FFWDRT     UF   F  611     3AIDISK    KEYLOC(2)                                          089129
     F*****************************************************************
      /EJECT
     F*****************************************************************
      **
     D DFW             S              5  0 DIM(25)                              NO. DAYS - FWDRT
     D RFW             S             12  8 DIM(25)                              RATE - FWDRT
     D PFW             S             10  6 DIM(25)                              POINTS - FWDRT
     D SFW             S              1    DIM(25)                              SIGN - FWDRT
     D PFD             S             13  8 DIM(25)                              POINTS - FWDRT
     I*****************************************************************
      /EJECT
     I*****************************************************************
0163 I*    FORWARD RATES FILE - DETAIL RECORD.
0164 I*
     IFWDRTFE   NS  01
     I                                  1    1  RECI
     I                                  2    4  CCY
     I                             P    5   79  DFW
     I                             P   80  254  RFW
     I                             P  255  257 0LCD
     I                                258  258  CHTP
     I                             P  259  261 0TNLU
     I                             P  262  411  PFW
     I                                412  436  SFW
     IFWDRT     NS  02    1 CD
     I         OR   02    1 C*
     I                                  1    1  RECI
     I                                  2    4  FCCY
     I*
      *
     C**   Access record to be updated
     C     CCY           CHAIN     FWDRT                              82
     C     *IN82         IFEQ      '0'
     C                   Z-ADD     0             A                 2 0
     C     LOOP          TAG
     C     A             ADD       1             A
     C                   Z-ADD     PFW(A)        PFD(A)
     C     A             IFLT      25
     C                   GOTO      LOOP
     C                   END
     C                   END
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     OFWDRT     D   N82 02
     O                       PFD                611P                                          089129
