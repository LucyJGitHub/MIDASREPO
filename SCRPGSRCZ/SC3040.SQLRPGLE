     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas SC Check switch. related objs - PFs')
     F*****************************************************************
     F*                                                               *
     F*  Midas - SYSTEM CONTROL MODULE
     F*                                                               *
     F*  SC3040 - CHECK FOR SWITCHABLE FEATURES RELATED OBJECTS       *
     F*           - PHYSICAL FILES                                    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01407             Date 05Jan93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD046248 - Finastra Rebranding                               *
     F*  S01407 - SWITCHABILITY ENHANCEMENTS                          *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*SCSAROJ0* IF   E           K DISK                                                    MD056555
      * Switchable Features - Objects : Select Switchable features related
      *                                  objects - PFs
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright     array
     D SCSARO        E DS                  EXTNAME(SCSROJW0)                                MD056555
      /EJECT
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** PARAMETERS PASSED FROM CLP/SCJRNBCH OR CLP/SCJRNMULT
      ** (PHYSICAL FILE AND JOURNALLING REQUIRED FLAG)
      *
     C     *ENTRY        PLIST
     C                   PARM                    #PFILE           10
     C                   PARM                    #PJRNR            1
      *
      ** CHECK IF PHYSICAL FILE HAS BEEN SET UP FOR A SWITCHABLE ENHANCEMENT
      *
     C*****#PFILE        SETLL     SCSAROD0                           20                    MD056555
     C*****#PFILE        CHAIN     SCSAROD0                           20                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ declare OCursor insensitive scroll cursor for                                       MD056555
     C+ select * from SCSROJW1                                                              MD056555
     C+ where AFOBNM = :#PFILE and AFOBTP = '*FILE' and AFOBAT = 'PF'                       MD056555
     C+ order by AFOBNM                                                                     MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ open OCursor                                                                        MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from OCursor into :SCSARO                                                MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
      *
      ** IF THE FILE HAS NOT BEEN SET UP FOR SWITCHABLE ENHANCEMENTS, THEN
      ** JOURNALLING REQUIRED FLAG #PJRNR GOES TO 'N' (PASSED BACK TO CALLING
      ** PROGRAMS).
      ** IF THE FILE HAS BEEN SET UP FOR SWITCHABLE ENHANCEMENT, THEN #PJRNR
      ** IS 'Y'
      *
     C******IN20         IFEQ      '0'                                                      MD056555
     C                   IF        SQLCODE = 0                                              MD056555
     C                   MOVEL     'Y'           #PJRNR
     C                   ELSE
     C                   MOVEL     'N'           #PJRNR
     C                   END
      *
     C/EXEC SQL                                                                             MD056555
     C+ close OCursor                                                                       MD056555
     C/END-EXEC                                                                             MD056555
      ** TERMINATE PROGRAM
      *
     C                   SETON                                        LR
     C                   RETURN
      *
** CPY@
(c) Finastra International Limited 2001
